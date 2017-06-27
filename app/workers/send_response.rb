class Goldblum
  class SendResponse
    include Sidekiq::Worker

    def perform(url, channel_id, real_name)
      HTTParty.post(
        url, {
          body: {
            channel:       channel_id,
            response_type: 'in_channel',
            text:          "#{real_name} has been Goldblum’d!",
          }.to_json,
          headers: {
            'Content-Type' => 'application/json'
          }
        }
      )
    end
  end
end
