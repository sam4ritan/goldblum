class Goldblum
  class UpdateMessage
    include Sidekiq::Worker

    def perform(user_id, timestamp, channel_id, text, attachments)
      Slack.api('chat.update', user_id, {
        ts:          timestamp,
        channel:     channel_id,
        text:        text,
        attachments: attachments,
      })
    end
  end
end
