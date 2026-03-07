module Damascord
  class Config
    class Error < StandardError; end

    attr_reader :discord_token, :gemini_api_key, :gemini_model, :master_user_id, :pollux_prompt,
                :goiabook_api_url, :goiabook_api_token

    def initialize
      load_env
      validate_keys!
      load_prompt
    end

    private

    def load_env
      require 'dotenv/load'
    end

    def validate_keys!
      @discord_token  = ENV['DISCORD_TOKEN']
      @gemini_api_key = ENV['GEMINI_API_KEY']
      @gemini_model   = ENV.fetch('GEMINI_MODEL', 'gemini-2.5-flash')
      @master_user_id = ENV['MASTER_USER_ID']
      @goiabook_api_url   = ENV.fetch('GOIABOOK_API_URL', 'http://127.0.0.1:3000/api/v1/bookmarks')
      @goiabook_api_token = ENV.fetch('GOIABOOK_API_TOKEN', 'damascord_goiaba_2026')

      missing = []
      missing << 'DISCORD_TOKEN'  if @discord_token.nil?  || @discord_token.empty?
      missing << 'GEMINI_API_KEY' if @gemini_api_key.nil? || @gemini_api_key.empty?
      missing << 'MASTER_USER_ID' if @master_user_id.nil? || @master_user_id.empty?

      unless missing.empty?
        raise Error, "ERRO: Variáveis obrigatórias ausentes no .env: #{missing.join(', ')}. Impossível operar no vácuo."
      end
    end

    def load_prompt
      prompt_path = File.join(File.dirname(__FILE__), '..', '..', 'data', 'ai_persona.md')
      begin
        @pollux_prompt = File.read(prompt_path).strip
      rescue Errno::ENOENT
        puts "Atenção: O arquivo data/ai_persona.md não foi encontrado. Vou usar a minha personalidade padrão de deboche leve, que decepção."
        @pollux_prompt = "Você é Pollux, a IA tradutora do Caos. Responda o usuário com acidez e sarcasmo."
      end
    end
  end
end
