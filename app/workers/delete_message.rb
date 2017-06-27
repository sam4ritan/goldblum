class Goldblum
  class DeleteMessage
    include Sidekiq::Worker

    def perform(user_id, timestamp, channel_id, sleep_timer = 0)
      sleep(sleep_timer)

      Slack.api('chat.delete', user_id, {
        ts: timestamp,
        channel: channel_id,
      })
    end
  end
end
