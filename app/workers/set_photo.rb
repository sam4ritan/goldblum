class Goldblum
  class SetPhoto
    include Sidekiq::Worker

    def perform(user_id, avatar_path)
      Slack.api('users.setPhoto',
        user_id: user_id,
        image: File.new(avatar_path),
        crop_x: 0,
        crop_y: 0,
        crop_w: 500,
      )
    end
  end
end
