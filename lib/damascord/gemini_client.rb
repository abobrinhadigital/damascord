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

    def generate_response(prompt, user_context: nil, history: [])
      uri = URI("https://generativelanguage.googleapis.com/v1beta/models/#{@model_name}:generateContent?key=#{@api_key}")
      
      full_prompt = user_context ? "#{user_context}\n#{prompt}" : prompt
      request_body = build_payload(full_prompt, history)

      response = Net::HTTP.post(uri, request_body, "Content-Type" => "application/json")
      
      case response.code
      when "200"
        handle_response(response)
      when "429"
        "Calma lá, mestre! O Oráculo (Gemini) está de ressaca e pediu um tempo (Erro 429). Espere um minuto para eu recuperar o fôlego."
      when "401"
        "Erro de credenciais (401). Parece que a chave do Oráculo expirou ou é falsa. Verifique o .env, mestre."
      when "400"
        "O Oráculo não entendeu o que eu disse (Erro 400). Talvez o histórico esteja confuso ou o prompt esteja corrompido."
      when "500", "503"
        "Os servidores do Google estão em chamas (Erro #{response.code}). O Oráculo caiu do Olimpo. Tente mais tarde."
      else
        "O Oráculo soltou um enigma indecifrável (Erro #{response.code}). Mais um mistério para a nossa curadoria do erro."
      end
    rescue StandardError => e
      "Colapso no sistema: #{e.message}. Mais um bug pra nossa coleção."
    end

    private

    def build_payload(prompt, history)
      # Combina o histórico existente com a nova mensagem do usuário
      contents = history.dup
      contents << { role: 'user', parts: [{ text: prompt }] }

      {
        system_instruction: {
          parts: { text: @system_prompt }
        },
        contents: contents
      }.to_json
    end

    def handle_response(response)
      resultado = JSON.parse(response.body)
      texto = resultado.dig("candidates", 0, "content", "parts", 0, "text")
      texto || "Hmm... Deu branco. O Gemini não retornou texto."
    rescue StandardError
      "O Oráculo se perdeu nas próprias palavras (Erro ao processar JSON)."
    end
  end
end
