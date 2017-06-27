class Goldblum
  class PostMessage
    include Sidekiq::Worker

    def perform(channel_id)
      Slack.api('chat.postMessage', {
        channel: channel_id,
        as_user: false,
        icon_emoji: ':goldblum:',
        text: 'I’ve been Goldblum’d!',
      })
    end
  end
end
