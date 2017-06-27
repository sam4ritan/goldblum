class Goldblum
  class SendResponse
    include Sidekiq::Worker

    def perform(url, body)
      HTTParty.post(
        url, {
          body: body.to_json,
          headers: {
            'Content-Type' => 'application/json'
          }
        }
      )
    end
  end
end
