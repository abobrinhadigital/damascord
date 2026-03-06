# frozen_string_literal: true

require 'json'
require 'fileutils'

module Damascord
  class MemoryManager
    HISTORY_DIR = 'data/history'
    MAX_HISTORY = 5 # Reduzido para evitar atingir limites de tokens/rate limit rapidamente

    def initialize
      FileUtils.mkdir_p(HISTORY_DIR)
    end

    def load_history(channel_id)
      path = history_path(channel_id)
      return [] unless File.exist?(path)

      JSON.parse(File.read(path))
    rescue StandardError => e
      puts "[ERRO ao carregar memória do canal #{channel_id}]: #{e.message}"
      []
    end

    def save_interaction(channel_id, user_msg, bot_msg)
      history = load_history(channel_id)
      
      # Adiciona o novo turno
      history << { role: 'user', parts: [{ text: user_msg }] }
      history << { role: 'model', parts: [{ text: bot_msg }] }

      # Poda o histórico para manter apenas o limite (cada turno tem 2 entradas)
      limit = MAX_HISTORY * 2
      history = history.last(limit) if history.size > limit

      File.write(history_path(channel_id), history.to_json)
    rescue StandardError => e
      puts "[ERRO ao salvar memória do canal #{channel_id}]: #{e.message}"
    end

    private

    def history_path(channel_id)
      File.join(HISTORY_DIR, "#{channel_id}.json")
    end
  end
end
