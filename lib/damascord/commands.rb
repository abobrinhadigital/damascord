# frozen_string_literal: true

module Damascord
  module Commands
    PREFIX = '!'.freeze

    def self.setup(bot, access_control)
      return if @already_setup
      
      setup_user_register(bot, access_control)
      setup_user_delete(bot, access_control)
      setup_channel_register(bot, access_control)
      setup_channel_delete(bot, access_control)
      setup_blog(bot, access_control)
      setup_help(bot, access_control)
      
      @already_setup = true
    end

    def self.setup_help(bot, ac)
      bot.message(start_with: "#{PREFIX}help") do |event|
        msg = "**Mandamentos do Pollux (Comandos):**\n"
        msg += "- `!blog`: Mostra o último post do blog Abobrinha Digital.\n"
        msg += "- `@Pollux [mensagem]`: Conversa com o biógrafo imortal (requer autorização).\n"
        
        if ac.master?(event.user.id)
          msg += "\n**Poderes do Mestre:**\n"
          msg += "- `!user_register @mortal`: Dá acesso a um novo navegante.\n"
          msg += "- `!user_delete @mortal`: Revoga o acesso de um infeliz.\n"
          msg += "- `!channel_register`: Autoriza este canal para o bot falar.\n"
          msg += "- `!channel_delete`: Silencia o bot neste canal.\n"
        end

        event.respond msg
      end
    end

    def self.setup_blog(bot, ac)
      bot.message(start_with: "#{PREFIX}blog") do |event|
        # Qualquer um autorizado pode ver o blog
        unless ac.user_allowed?(event.user.id)
          event.respond "Acesso negado. Até o blog é um privilégio para os escolhidos."
          next
        end

        feed = FeedManager.new
        post = feed.fetch_latest_post
        
        if post
          # Tenta extrair a URL de várias formas comuns em objetos RSS/Atom
          url = if post.respond_to?(:link)
                  post.link.respond_to?(:href) ? post.link.href : post.link.to_s
                elsif post.respond_to?(:url)
                  post.url
                else
                  "Link não encontrado"
                end

          titulo = post.title.to_s.gsub(/<\/?[^>]*>/, "").strip
          event.respond "Aqui está a última abobrinha do mestre:\n**#{titulo}**\n#{url}"
        else
          puts "[ERRO !blog]: Não foi possível obter o post do FeedManager."
          event.respond "O oráculo do blog está em silêncio... ou o mestre quebrou o RSS (de novo)."
        end
      end
    end

    def self.setup_user_register(bot, ac)
      bot.message(start_with: "#{PREFIX}user_register") do |event|
        next unless ac.master?(event.user.id)

        target = event.message.mentions.first
        unless target
          event.respond "Uso correto: `!user_register @usuário` — mencione alguém, meu senhor."
          next
        end

        if ac.register_user(target.id, target.name)
          event.respond "Usuário **#{target.name}** registrado com sucesso. Mais uma alma nas mãos do destino."
        else
          event.respond "**#{target.name}** já estava na lista. Memória fraca, meu senhor."
        end
      end
    end

    def self.setup_user_delete(bot, ac)
      bot.message(start_with: "#{PREFIX}user_delete") do |event|
        next unless ac.master?(event.user.id)

        target = event.message.mentions.first
        unless target
          event.respond "Uso correto: `!user_delete @usuário` — mencione quem quer banir."
          next
        end

        if ac.delete_user(target.id)
          event.respond "Usuário **#{target.name}** removido. O acesso foi revogado com a frieza que o cargo exige."
        else
          event.respond "**#{target.name}** nem estava na lista. Tudo bem, até os erros têm sua graça."
        end
      end
    end

    def self.setup_channel_register(bot, ac)
      bot.message(start_with: "#{PREFIX}channel_register") do |event|
        next unless ac.master?(event.user.id)

        channel = event.channel
        if ac.register_channel(channel.id, channel.name)
          event.respond "Canal **##{channel.name}** registrado. Agora eu posso falar por aqui — sob protesto, claro."
        else
          event.respond "Canal **##{channel.name}** já estava na lista."
        end
      end
    end

    def self.setup_channel_delete(bot, ac)
      bot.message(start_with: "#{PREFIX}channel_delete") do |event|
        next unless ac.master?(event.user.id)

        channel = event.channel
        if ac.delete_channel(channel.id)
          event.respond "Canal **##{channel.name}** removido. Silêncio restaurado neste recanto."
        else
          event.respond "Canal **##{channel.name}** não estava na lista de qualquer forma."
        end
      end
    end
  end
end
