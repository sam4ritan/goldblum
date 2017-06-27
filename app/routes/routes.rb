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

  post '/' do
    content_type :json, charset: 'utf-8'

    # Later on…
    # if params['token'] != settings.slack_token
    #   status 401
    #   {
    #     "error" => "Incorrect Slack token"
    #   }.to_json
    # end

    user_id       = params['user_id']
    user          = Slack.api('users.profile.get', user_id)
    real_name     = user['profile']['real_name']
    first_name    = user['profile']['first_name']
    email_address = user['profile']['email']

    # Set status
    SetProfile.perform_async(user_id)

    # Set avatar
    SetPhoto.perform_async(user_id)

    # Post a message
    # PostMessage.perform_async(settings.channel_id)

    # Send response back to Slack
    SendResponse.perform_async(params['response_url'], settings.channel_id, real_name)

    # TODO: fire off email
    # SendEmail.perform_async(email_address, first_name, real_name)

    # returning nil will ensure the command doesn’t output anything else

    {
      "response_type": "in_channel",
      "text": "Initiating Goldblum protocol…"
    }.to_json
  end
end
