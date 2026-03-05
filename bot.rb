require_relative 'lib/damascord'

config = Damascord::Config.new
Damascord::Bot.new(config).start

