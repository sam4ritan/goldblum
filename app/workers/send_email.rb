class Goldblum
  class SendEmail
    include Sidekiq::Worker
    include Sinatra::Templates

    def perform(user_id, character)
      user        = Goldblum::Slack.api('users.profile.get', user_id: user_id)
      smtp_config = {
        user_name:            ENV['SMTP_USER_NAME'],
        password:             ENV['SMTP_PASSWORD'],
        domain:               ENV['SMTP_DOMAIN'],
        address:              ENV['SMTP_ADDRESS'],
        port:                 ENV['SMTP_PORT'],
        authentication:       ENV['SMTP_AUTHENTICATION'].to_sym,
        enable_starttls_auto: ENV['SMTP_ENABLETLS'] == 'true',
      }

      result = Pony.mail({
        to:             user['profile']['email'],
        from:           "IT Support <it.support@deliveroo.co.uk>",
        subject:        'You’ve been Goldblum’d!',
        html_body:      Goldblum.new.helpers.erb(:email, {}, locals: {
          image_url:    character['avatar_path'],
          hero_heading: "#{character['first_name']} #{character['last_name']}",
          hero_text:    "“#{character['quote']}”",
        }),
        via:            :smtp,
        via_options:    smtp_config
      })
    end
  end
end
