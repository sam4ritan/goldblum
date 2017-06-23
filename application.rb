require 'bundler'
Bundler.require

class PoopMail < Sinatra::Base
  # generic application settings
  settings = YAML.load(File.new('./config/application.yml'))
  settings.each_pair do |key, value|
    set key.to_sym, value
  end

  # mailer settings
  configure :development do
    set :smtp_config, YAML.load(File.new('./config/smtp.yml'))
    set :slack_token, YAML.load(File.new('./config/slack.yml'))[:token]
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

      set :slack_token, ENV['SLACK_TOKEN']
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'app/**/*.rb')].sort.each { |f| require f }

if __FILE__ == $0
  PoopMail.run!
end
