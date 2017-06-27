class Goldblum
  class SendResponse
    include Sidekiq::Worker

    def perform(url, channel_id, response_type, text)
      HTTParty.post(
        url, {
          body: {
            channel:       channel_id,
            response_type: response_type,
            text:          text,
          }.to_json,
          headers: {
            'Content-Type' => 'application/json'
          }
        }
      )
    end
  end
end
