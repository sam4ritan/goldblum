class Goldblum < Sinatra::Base

  # example posted data
  # token=gIkuvaNzQIHg97ATvDxqgjtO
  # team_id=T0001
  # team_domain=example
  # enterprise_id=E0001
  # enterprise_name=Globular%20Construct%20Inc
  # channel_id=C2147483705
  # channel_name=test
  # user_id=U2147483697
  # user_name=Steve
  # command=/weather
  # text=94070
  # response_url=https://hooks.slack.com/commands/1234/5678

  def slack_api(action, user_id, params = {})
    HTTParty.post("https://slack.com/api/#{action}", {
      body: {
        token: settings.slack_oauth_token,
        user: user_id,
      }.merge(params),
      headers: { }
    })
  end

  post '/' do
    content_type :json, charset: 'utf-8'

    # Later on…
    # if params['token'] != settings.slack_token
    #   status 401
    #   {
    #     "error" => "Incorrect Slack token"
    #   }.to_json
    # end

    user = slack_api('users.profile.get', params['user_id'])

    slack_api('users.profile.set', params['user_id'], {
      profile: {
        status_emoji: ':goldblum:',
        status_text: 'I’ve been Goldblum’d',
      }.to_json,
    })

    content_body = {
      channel:       'C28F0KLBD',
      response_type: 'in_channel',
      text:          "#{user['profile']['real_name']} has been Goldblum’d!",
    }.to_json

    HTTParty.post(
      params['response_url'],
      {
        body:    content_body,
        headers: {
          'Content-Type' => 'application/json'
        }
      }
    )

    # TODO: fire off email
    # user['profile']['email']

    # return nil to ensure the command doesn’t output anything else
    nil
  end
end
