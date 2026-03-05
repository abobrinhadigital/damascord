# frozen_string_literal: true

require 'discordrb'

module Damascord
  class Bot
    def initialize(config)
      @config = config
      @client = Discordrb::Bot.new(token: @config.discord_token, intents: [:server_messages, :direct_messages])
      @gemini = GeminiClient.new(@config.gemini_api_key, @config.pollux_prompt, @config.gemini_model)
      @access = AccessControl.new(@config.master_user_id)

      Commands.setup(@client, @access)
      @notifier = PostNotifier.new(@client, @config, @access)
      
      setup_events
    end

    def start
      puts "Iniciando o Damascord Protocol... Pollux acordando do sono de beleza."
      puts "Master configurado: #{@config.master_user_id}"
      @notifier.start_monitoring
      @client.run
    end

    private

    def setup_events
      @client.message do |event|
        handle_message(event)
      end
    end

    def handle_message(event)
      return if event.user.bot_account
      # Comandos de prefixo ! são tratados pelo Commands, não chegam aqui
      return if event.message.content.start_with?(Commands::PREFIX)

      return unless mentioned_or_pm?(event)
      return unless authorized?(event)

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
      
      # Anexa o contexto do usuário explicitamente
      user_context = "[Usuário: #{event.user.name} | ID: #{event.user.id}]"
      resposta = @gemini.generate_response(texto_limpo, user_context: user_context)

      puts "\n[GEMINI Resposta]:\n#{resposta}\n"
      send_response(event, resposta)
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
