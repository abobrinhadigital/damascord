# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module Damascord
  class GoiabookClient
    class Error < StandardError; end

    def initialize(url, token)
      @url = URI(url)
      @token = token
    end

    def post_bookmark(url)
      request = Net::HTTP::Post.new(@url)
      request["Content-Type"] = "application/json"
      request["X-Api-Token"] = @token
      request.body = { url: url }.to_json

      response = Net::HTTP.start(@url.hostname, @url.port, use_ssl: @url.scheme == 'https') do |http|
        http.request(request)
      end

      case response.code
      when "201", "200"
        JSON.parse(response.body)
      else
        raise Error, "Erro ao cadastrar na Goiaba: #{response.code} - #{response.body}"
      end
    rescue StandardError => e
      raise Error, "Falha na comunicação com o GoiabookLM: #{e.message}"
    end
  end
end
