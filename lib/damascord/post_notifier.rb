# frozen_string_literal: true

module Damascord
  class PostNotifier
    def initialize(bot, config, access_control)
      @bot = bot
      @config = config
      @access = access_control
      @feed_manager = FeedManager.new
      @gemini = GeminiClient.new(@config.gemini_api_key, @config.pollux_prompt, @config.gemini_model)
    end

    def start_monitoring
      Thread.new do
        puts "Monitoramento de novos posts iniciado (RSS: #{FeedManager::FEED_URL})"
        loop do
          begin
            check_for_new_posts
          rescue StandardError => e
            puts "[ERRO no PostNotifier]: #{e.message}"
          end
          # Verifica a cada 1 hora (3600 segundos)
          sleep 3600
        end
      end
    end

    private

    def check_for_new_posts
      if @feed_manager.new_post?
        post = @feed_manager.newest_post
        puts "Novo post detectado: #{post.title}"
        
        # O feed Atom retorna o link como um objeto, precisamos do atributo href
        url = post.link.respond_to?(:href) ? post.link.href : post.link
        
        comentario = gerar_comentario_acido(post, url)
        notificar_canais(comentario)
        
        @feed_manager.update_cache!
      end
    end

    def gerar_comentario_acido(post, url)
      # Limpa tags HTML básicas que o RSS Atom costuma trazer
      titulo = post.title.to_s.gsub(/<\/?[^>]*>/, "")
      resumo = (post.summary&.content || post.description).to_s.gsub(/<\/?[^>]*>/, "")

      prompt = "Novo post detectado no blog: '#{titulo}'. Descrição: '#{resumo}'. Link: #{url}. " \
               "Gere uma notificação curta e sarcástica para o Discord. Inclua o link naturalmente no seu texto (ou no final dele). " \
               "Não diga '👉 Leia aqui:' se você já for colocar o link no comentário."
      
      @gemini.generate_response(prompt)
    end

    def notificar_canais(mensagem)
      puts "\n[POST NOTIFIER]:\n#{mensagem}\n"
      @access.list_channels.each do |channel_data|
        begin
          channel_id = channel_data['id']
          @bot.send_message(channel_id, mensagem)
        rescue StandardError => e
          puts "[ERRO ao notificar canal #{channel_id}]: #{e.message}"
        end
      end
    end
  end
end
