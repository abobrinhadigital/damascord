# frozen_string_literal: true

require 'discordrb'

module Damascord
  class Bot
    def initialize(config)
      @config = config
      @client = Discordrb::Bot.new(token: @config.discord_token, intents: [:server_messages, :direct_messages])
      @memory = MemoryManager.new
      @gemini = GeminiClient.new(@config.gemini_api_key, @config.pollux_prompt, @config.gemini_model)
      @access = AccessControl.new(@config.master_user_id)

      Commands.setup(@client, @access)
      @notifier = PostNotifier.new(@client, @config, @access)
      @goiabook = GoiabookClient.new(@config.goiabook_api_url, @config.goiabook_api_token)
      
      # Registra o evento de mensagem apenas uma vez
      @client.message do |event|
        handle_message(event)
      end
    end

    def start
      puts "Iniciando o Damascord Protocol... Pollux acordando do sono de beleza."
      puts "Master configurado: #{@config.master_user_id}"
      @notifier.start_monitoring
      @client.run
    end

    private

    # Removido setup_events para evitar redundância

    def handle_message(event)
      return if event.user.bot_account
      # Comandos de prefixo ! são tratados pelo Commands, não chegam aqui
      return if event.message.content.start_with?(Commands::PREFIX)

      return unless mentioned_or_pm?(event)
      return unless authorized?(event)

      if should_forward_to_goiabook?(event)
        return if process_goiabook_forwarding(event)
      end

      process_gemini_response(event)
    end

    def mentioned_or_pm?(event)
      event.message.mentions.any? { |u| u.id == @client.profile.id } || event.channel.pm?
    end

    def authorized?(event)
      unless @access.user_allowed?(event.user.id)
        event.respond "Acesso negado. Você não foi autorizado pelo mestre. O destino é implacável."
        return false
      end

      # Master fala em qualquer canal; DMs também são livres de restrição
      return true if @access.master?(event.user.id) || event.channel.pm?

      unless @access.channel_allowed?(event.channel.id)
        return false
      end

      true
    end

    def process_gemini_response(event)
      texto_limpo = event.message.content.gsub(/<@!?#{@client.profile.id}>/, "").strip

      if texto_limpo.empty?
        event.respond "Diga, mestre. Já encontrou um novo jeito de quebrar nosso código hoje?"
        return
      end

      event.channel.start_typing
      
      # Carrega o histórico do canal e gera resposta com contexto
      history = @memory.load_history(event.channel.id)
      user_context = "[Usuário: #{event.user.name} | ID: #{event.user.id}]"
      
      resposta = @gemini.generate_response(texto_limpo, user_context: user_context, history: history)

      # Salva a nova interação na memória
      @memory.save_interaction(event.channel.id, "#{user_context}\n#{texto_limpo}", resposta)

      send_response(event, resposta)
    end

    def should_forward_to_goiabook?(event)
      return false unless @access.master?(event.user.id)
      return false unless event.channel.pm?

      # Regex simples para URL
      event.message.content.match?(URI::DEFAULT_PARSER.make_regexp(['http', 'https']))
    end

    def process_goiabook_forwarding(event)
      # Pega a primeira URL encontrada
      url = event.message.content.match(URI::DEFAULT_PARSER.make_regexp(['http', 'https']))[0]
      
      # Se a mensagem tiver MAIS do que apenas a URL, não retornamos true aqui,
      # permitindo que o Gemini processe o comentário associado.
      # Mas se for SÓ a URL, nós barramos o Gemini para economizar token.
      apenas_url = event.message.content.strip == url

      begin
        @goiabook.post_bookmark(url)
        event.respond "Link cadastrado no GoiabookLM, mestre."
        return apenas_url
      rescue StandardError => e
        puts "Erro Goiabook: #{e.message}"
        event.respond "Tentei avisar a Goiaba, mas ela engasgou: #{e.message}"
        return true # Barramos o Gemini para não confundir mais as coisas
      end
    end

    def send_response(event, text)
      if text.length > 2000
        event.respond text[0..1990] + "..."
      else
        event.respond text
      end
    end
  end
end
