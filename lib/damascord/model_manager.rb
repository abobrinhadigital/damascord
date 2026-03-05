# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module Damascord
  class ModelManager
    GEMINI_MODELS_URL = "https://generativelanguage.googleapis.com/v1beta/models"

    def initialize(api_key)
      @api_key = api_key
    end

    def available_models
      uri = URI("#{GEMINI_MODELS_URL}?key=#{@api_key}")
      response = Net::HTTP.get_response(uri)

      unless response.is_a?(Net::HTTPSuccess)
        raise "Falha ao buscar modelos: #{response.code} - #{response.message}"
      end

      resultado = JSON.parse(response.body)
      resultado["models"] || []
    rescue StandardError => e
      puts "[ERRO MURPHYANO ao buscar modelos]: #{e.message}"
      []
    end

    def list_models
      puts "Consultando os oráculos do Gemini... aguarde enquanto o universo decide cooperar.\n\n"

      models = available_models

      if models.empty?
        puts "Nenhum modelo retornado. Murphy venceu desta vez."
        return
      end

      # Filtra apenas modelos que suportam geração de conteúdo
      generative_models = models.select do |m|
        m["supportedGenerationMethods"]&.include?("generateContent")
      end

      puts "Modelos disponíveis para generateContent:"
      puts "-" * 50
      generative_models.each do |model|
        name = model["name"].gsub("models/", "")
        display = model["displayName"] || name
        puts " • #{name.ljust(40)} #{display}"
      end
      puts "\nDica do seu biógrafo: coloque o nome desejado em GEMINI_MODEL no .env."
    end
  end
end
