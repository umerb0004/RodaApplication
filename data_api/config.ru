require 'bundler/setup'
require 'sidekiq'

require_relative 'api'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end

run API.freeze.app
