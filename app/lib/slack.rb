class Goldblum
  class Slack
    include HTTMultiParty
    base_uri 'https://slack.com/'

    def self.api(action, user_id: nil, **params)
      post_params = {
        body: {
          token: Goldblum.settings.slack_oauth_token,
          user: user_id,
        }.merge(params),
        headers: { }
      }

      puts "<post to=\"#{base_uri}/api/#{action}\">"
      puts JSON.pretty_generate(post_params)
      puts "</post>"

      response = post("/api/#{action}", post_params)

      puts "<response>"
      puts URI.decode(response.body)
      puts "</response>"

      response
    end
  end
end
