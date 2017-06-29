class Goldblum
  class PostMessage
    include Sidekiq::Worker

    def perform(channel_id, text, attachments = [])
      Slack.api('chat.postMessage',
        channel:    channel_id,
        as_user:    false,
        icon_emoji: ':goldblum:',
        text:       text,
        attachment: URI.encode(attachments.to_json),
      )
    end
  end
end
