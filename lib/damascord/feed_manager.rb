# frozen_string_literal: true

require 'rss'
require 'open-uri'
require 'yaml'

module Damascord
  class FeedManager
    FEED_URL = 'https://abobrinhadigital.github.io/feed.xml'
    CACHE_FILE = File.expand_path('../../data/last_post.yml', __dir__)

    def initialize
      @last_post_link = load_cache
    end

    def new_post?
      latest_post = fetch_latest_post
      return false if latest_post.nil?
      
      # Se o link do post mais recente for diferente do que temos no cache
      if latest_post.link != @last_post_link
        @newest_post = latest_post
        return true
      end

      false
    end

    def newest_post
      @newest_post
    end

    def update_cache!
      return if @newest_post.nil?
      
      @last_post_link = @newest_post.link
      File.write(CACHE_FILE, { 'last_post_link' => @last_post_link }.to_yaml)
    end

    private

    def fetch_latest_post
      URI.open(FEED_URL) do |rss|
        feed = RSS::Parser.parse(rss)
        # O jekyll-feed gera um Atom feed, então usamos .items ou .entries
        feed.items.first
      end
    rescue StandardError => e
      puts "[ERRO ao buscar feed]: #{e.message}"
      nil
    end

    def load_cache
      return nil unless File.exist?(CACHE_FILE)
      data = YAML.load_file(CACHE_FILE)
      data['last_post_link']
    rescue StandardError
      nil
    end
  end
end
