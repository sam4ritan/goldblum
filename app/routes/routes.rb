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
    {
      "text": "Initiate Goldblum protocol?",
      "attachments": [
        {
          "fallback": "You are unable to Goldblum :sob:",
          "callback_id": "goldblum_#{Time.now.to_i.base62_encode}",
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
                "title": "Initiate Goldblum protocol on this user",
                "text": "Are you sure?",
                "ok_text": "Yes, do it!",
                "dismiss_text": "On second thoughts…"
              }
            }
          ]
        }
      ]
    }.to_json
  end

  post '/goldblum' do
    payload       = JSON.parse(URI.decode(params['payload']))
    action_value  = payload['actions'].first['value']
    channel_id    = payload['channel']['id']
    action_ts     = payload['action_ts']
    message_ts    = payload['message_ts']
    user_id       = payload['user']['id']

    PrintJSON.perform_async(payload)

    if action_value === 'proceed'
      # proceed with Goldblum
      user_name     = payload['user']['name']
      response_url  = payload['response_url']
      character     = RandomCharacter.get

      # Set status
      SetProfile.perform_async(user_id, character)

      # Set avatar
      SetPhoto.perform_async(user_id, "public/#{character[:avatar_path]}")

      # Post a message
      PostMessage.perform_async(settings.channel_id, "@#{user_name} has transformed into :goldblum: *#{character[:first_name]} #{character[:last_name]}*!")

      # Clear the in progress message
      SendResponse.perform_async(response_url, {
        delete_original: true,
      })

      # Send an email message
      SendEmail.perform_async(user_id, character)

      {
        text: 'Initiating Goldblum protocol…'
      }.to_json
    else
      # cancel and remove the message(s)
      {
        delete_original: true
      }.to_json
    end
  end
end
