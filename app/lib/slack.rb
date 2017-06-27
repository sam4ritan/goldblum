class Goldblum
  class Slack
    include HTTMultiParty
    base_uri 'https://slack.com/'

    def self.api(action, user_id, params = {})
      post("/api/#{action}", {
        body: {
          token: Goldblum.settings.slack_oauth_token,
          user: user_id,
        }.merge(params),
        headers: { }
      })
    end
  end
end
