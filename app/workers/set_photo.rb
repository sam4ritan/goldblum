class Goldblum
  class SetPhoto
    include Sidekiq::Worker

    def perform(user_id)
      filepath = "app/avatars/#{sprintf("%03d", rand(1..25))}.jpg"

      Slack.api('users.setPhoto', user_id, {
        image: File.new(filepath),
        crop_x: 0,
        crop_y: 0,
        crop_w: 500,
      })
    end
  end
end
