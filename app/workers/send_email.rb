class Goldblum
  class SendEmail
    include Sidekiq::Worker

    def perform(user_id)
      # TODO: implementation
      user          = Slack.api('users.profile.get', user_id)
      real_name     = user['profile']['real_name']
      first_name    = user['profile']['first_name']
      email_address = user['profile']['email']
    end
  end
end
