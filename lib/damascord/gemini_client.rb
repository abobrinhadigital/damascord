require 'net/http'
require 'uri'
require 'json'

module Damascord
  class GeminiClient
    class Error < StandardError; end

    def initialize(api_key, system_prompt, model_name = 'gemini-2.0-flash')
      @api_key = api_key
      @system_prompt = system_prompt
      @model_name = model_name.to_s.gsub(/\Amodels\//, '')
    end

    def generate_response(prompt, user_context: nil)
      uri = URI("https://generativelanguage.googleapis.com/v1beta/models/#{@model_name}:generateContent?key=#{@api_key}")
      
      full_prompt = user_context ? "#{user_context}\n#{prompt}" : prompt
      request_body = build_payload(full_prompt)

      response = Net::HTTP.post(uri, request_body, "Content-Type" => "application/json")
      
      handle_response(response)
    rescue StandardError => e
      "Colapso no sistema: #{e.message}. Mais um bug pra nossa coleção."
    end

    private

    def build_payload(prompt)
      {
        system_instruction: {
          parts: { text: @system_prompt }
        },
        contents: [
          {
            parts: [
              { text: prompt }
            ]
          }
        ]
      }.to_json
    end

    def handle_response(response)
      if response.is_a?(Net::HTTPSuccess)
        resultado = JSON.parse(response.body)
        texto = resultado.dig("candidates", 0, "content", "parts", 0, "text")
        texto || "Hmm... Deu branco. O Gemini não retornou texto."
      else
        "Erro de comunicação com o Oráculo (Gemini API): #{response.code} - #{response.message}\nProvavelmente você esqueceu de pagar a conta ou quebrou algo."
      end
    end
  end
end
