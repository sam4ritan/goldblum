require 'bundler'
Bundler.require

class Goldblum < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/app/views'

  # mailer settings
  configure :development do
    slack_tokens = YAML.load(File.new('./config/slack.yml'))
    set :slack_token,       slack_tokens[:token]
    set :slack_oauth_token, slack_tokens[:oauth_token]
  end

  [:staging, :production].each do |environment|
    configure environment do
      set :slack_token,       ENV['SLACK_TOKEN']
      set :slack_oauth_token, ENV['SLACK_OAUTH_TOKEN']
      set :channel_id,        ENV['SLACK_CHANNEL_ID']

      Sidekiq.configure_client do |config|
        config.redis = { url: ENV['REDIS_URL'] }
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'app/**/*.rb')].sort.each { |f| require f }

if __FILE__ == $0
  Goldblum.run!
end
