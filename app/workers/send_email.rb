class Goldblum
  class SendEmail
    include Sidekiq::Worker

    def perform(email_address, first_name, real_name)
      # TODO: implementation
    end
  end
end
