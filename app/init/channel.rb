require './app/lib/slack'

class Goldblum
  [:staging, :production].each do |environment|
    configure environment do
      channel = Slack.api('channels.list')['channels'].find {|c| c['name'] == settings.channel }
      set :channel_id, channel['id']
    end
  end
end
