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

    if settings.perform_goldblum
      # Set status
      SetProfile.perform_async(user_id)

      # Set avatar
      SetPhoto.perform_async(user_id)

      # TODO: Post a message (alternative to SendResponse)
      # PostMessage.perform_async(settings.channel_id)

      # Send response back to Slack
      SendResponse.perform_async(params['response_url'], settings.channel_id, real_name)

      # TODO: fire off email
      # SendEmail.perform_async(email_address, first_name, real_name)
    end

    {
      "response_type": "ephemeral",
      "text": "Initiate Goldblum protocol?",
      "attachments": [
        "fallback": "You are unable to Goldblum",
        "callback_id": "goldblum",
        "color": "#ff0000",
        "attachment_type": "default",
        "actions": [
          {
            "name": "action",
            "text": "Cancel",
            "type": "button",
            "value": "cancel"
          },
          {
            "name": "action",
            "text": "Proceed",
            "style": "danger",
            "type": "button",
            "value": "proceed",
            "confirm": {
              "title": "Execute Goldblum protocol on this user",
              "text": "Are you sure?",
              "ok_text": "Yes, do it!",
              "dismiss_text": "On second thoughts, no"
            }
          }
        ]
      ]
    }.to_json
  end

  post '/goldblum' do
    # TODO: message button action endpoint
  end
end
