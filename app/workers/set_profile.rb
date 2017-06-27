class Goldblum
  class SetProfile
    include Sidekiq::Worker

    def perform(user_id)
      Slack.api('users.profile.set', user_id, {
        profile: {
          status_emoji: ':goldblum:',
          status_text: 'I’ve been Goldblum’d!',
          title: Quote.get,
        }.merge(Character.get).to_json,
      })
    end
  end
end
