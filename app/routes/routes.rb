class Goldblum < Sinatra::Base
  def slack_token
    if params.has_key? 'payload'
      payload = JSON.parse(URI.decode(params['payload']))
      payload['token']
    else
      params['token']
    end
  end

  before do
    content_type :json, charset: 'utf-8'

    if slack_token == settings.slack_token
      return
    else
      status 401
      {
        "error" => "Incorrect Slack token"
      }.to_json
    end
  end

  post '/invoke' do
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

    callback_id = "goldblum_#{Time.now.to_i.base62_encode}"

    {
      "response_type": "ephemeral",
      "text": "Initiate Goldblum protocol?",
      "attachments": [
        "fallback": "You are unable to Goldblum :sob:",
        "callback_id": callback_id,
        "color": "#ff0000",
        "attachment_type": "default",
        "actions": [
          {
            "name": "execute",
            "text": "Cancel",
            "type": "button",
            "value": "cancel"
          },
          {
            "name": "execute",
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

    # example JSON payload submitted to this endpoint
    # {
    #   "actions": [
    #     {
    #       "name": "recommend",
    #       "value": "yes",
    #       "type": "button"
    #     }
    #   ],
    #   "callback_id": "comic_1234_xyz",
    #   "team": {
    #     "id": "T47563693",
    #     "domain": "watermelonsugar"
    #   },
    #   "channel": {
    #     "id": "C065W1189",
    #     "name": "forgotten-works"
    #   },
    #   "user": {
    #     "id": "U045VRZFT",
    #     "name": "brautigan"
    #   },
    #   "action_ts": "1458170917.164398",
    #   "message_ts": "1458170866.000004",
    #   "attachment_id": "1",
    #   "token": "xAB3yVzGS4BQ3O9FACTa8Ho4",
    #   "original_message": {"text":"New comic book alert!","attachments":[{"title":"The Further Adventures of Slackbot","fields":[{"title":"Volume","value":"1","short":true},{"title":"Issue","value":"3","short":true}],"author_name":"Stanford S. Strickland","author_icon":"https://api.slack.comhttps://a.slack-edge.com/bfaba/img/api/homepage_custom_integrations-2x.png","image_url":"http://i.imgur.com/OJkaVOI.jpg?1"},{"title":"Synopsis","text":"After @episod pushed exciting changes to a devious new branch back in Issue 1, Slackbot notifies @don about an unexpected deploy..."},{"fallback":"Would you recommend it to customers?","title":"Would you recommend it to customers?","callback_id":"comic_1234_xyz","color":"#3AA3E3","attachment_type":"default","actions":[{"name":"recommend","text":"Recommend","type":"button","value":"recommend"},{"name":"no","text":"No","type":"button","value":"bad"}]}]},
    #   "response_url": "https://hooks.slack.com/actions/T47563693/6204672533/x7ZLaiVMoECAW50Gw1ZYAXEM"
    # }

    payload = JSON.parse(URI.decode(params['payload']))

    action_value  = payload['actions'].first['value']
    user_id       = payload['user']['id']
    user          = Slack.api('users.profile.get', user_id)
    real_name     = user['profile']['real_name']
    first_name    = user['profile']['first_name']
    email_address = user['profile']['email']
    response_url  = payload['response_url']

    # Set status
    SetProfile.perform_async(user_id)

    # Set avatar
    SetPhoto.perform_async(user_id)

    # TODO: Post a message (alternative to SendResponse)
    # PostMessage.perform_async(settings.channel_id)

    # Send response back to Slack
    SendResponse.perform_async(response_url, settings.channel_id, real_name)

    # TODO: fire off email
    # SendEmail.perform_async(email_address, first_name, real_name)
  end
end
