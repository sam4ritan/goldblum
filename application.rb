require 'bundler'
Bundler.require

class Goldblum < Sinatra::Base
  # generic application settings
  settings = YAML.load(File.new('./config/application.yml'))
  settings.each_pair do |key, value|
    set key.to_sym, value
  end

  # debugging the command
  set :perform_goldblum, false

  # mailer settings
  configure :development do
    set :smtp_config,       YAML.load(File.new('./config/smtp.yml'))
    slack_tokens          = YAML.load(File.new('./config/slack.yml'))
    set :slack_token,       slack_tokens[:token]
    set :slack_oauth_token, slack_tokens[:oauth_token]
  end

  [:staging, :production].each do |environment|
    configure environment do
      set :smtp_config, {
        user_name:            ENV['SMTP_USER_NAME'],
        password:             ENV['SMTP_PASSWORD'],
        domain:               ENV['SMTP_DOMAIN'],
        address:              ENV['SMTP_ADDRESS'],
        port:                 ENV['SMTP_PORT'],
        authentication:       ENV['SMTP_AUTHENTICATION'].to_sym,
        enable_starttls_auto: ENV['SMTP_ENABLETLS'] == 'true',
      }

      set :slack_token,       ENV['SLACK_TOKEN']
      set :slack_oauth_token, ENV['SLACK_OAUTH_TOKEN']

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
