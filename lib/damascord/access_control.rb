# frozen_string_literal: true

require 'yaml'

module Damascord
  class AccessControl
    USERS_FILE    = File.expand_path('../../data/users.yml', __dir__)
    CHANNELS_FILE = File.expand_path('../../data/channels.yml', __dir__)

    def initialize(master_id)
      @master_id = master_id.to_s
    end

    # --- Verificações ---

    def master?(user_id)
      user_id.to_s == @master_id
    end

    def user_allowed?(user_id)
      return true if master?(user_id)
      authorized_users.any? { |u| u['id'].to_s == user_id.to_s }
    end

    def channel_allowed?(channel_id)
      authorized_channels.any? { |c| c['id'].to_s == channel_id.to_s }
    end

    # --- Usuários ---

    def register_user(id, name)
      users = authorized_users
      return false if users.any? { |u| u['id'].to_s == id.to_s }

      users << { 'id' => id.to_s, 'name' => name, 'added_at' => Time.now.strftime('%Y-%m-%d') }
      save_yaml(USERS_FILE, 'users', users)
      true
    end

    def delete_user(id)
      users = authorized_users
      before = users.size
      users.reject! { |u| u['id'].to_s == id.to_s }
      save_yaml(USERS_FILE, 'users', users)
      users.size < before
    end

    def list_users
      authorized_users
    end

    # --- Canais ---

    def register_channel(id, name)
      channels = authorized_channels
      return false if channels.any? { |c| c['id'].to_s == id.to_s }

      channels << { 'id' => id.to_s, 'name' => name, 'added_at' => Time.now.strftime('%Y-%m-%d') }
      save_yaml(CHANNELS_FILE, 'channels', channels)
      true
    end

    def delete_channel(id)
      channels = authorized_channels
      before = channels.size
      channels.reject! { |c| c['id'].to_s == id.to_s }
      save_yaml(CHANNELS_FILE, 'channels', channels)
      channels.size < before
    end

    def list_channels
      authorized_channels
    end

    private

    def authorized_users
      load_yaml(USERS_FILE, 'users')
    end

    def authorized_channels
      load_yaml(CHANNELS_FILE, 'channels')
    end

    def load_yaml(path, key)
      return [] unless File.exist?(path)
      data = YAML.load_file(path)
      (data && data[key]) || []
    end

    def save_yaml(path, key, data)
      File.write(path, { key => data }.to_yaml)
    end
  end
end
