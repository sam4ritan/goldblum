class Goldblum
  class PostMessage
    include Sidekiq::Worker

    def perform(user_id, channel_id, text, attachments = [])
      Slack.api('chat.postMessage', user_id, {
        channel:    channel_id,
        as_user:    false,
        icon_emoji: ':goldblum:',
        text:       text,
        attachment: URI.encode(attachments.to_json),
      })
    end
  end
end
