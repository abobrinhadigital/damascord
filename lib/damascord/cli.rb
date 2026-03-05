# frozen_string_literal: true

require 'thor'

module Damascord
  class CLI < Thor
    desc "start", "Inicia o bot Pollux no Discord"
    def start
      config = Config.new
      Bot.new(config).start
    end

    desc "models", "Lista os modelos do Gemini disponíveis para uso"
    def models
      config = Config.new
      ModelManager.new(config.gemini_api_key).list_models
    end

    def self.exit_on_failure?
      true
    end
  end
end
