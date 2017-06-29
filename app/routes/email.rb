class Goldblum < Sinatra::Base
  get '/email' do
    content_type 'text/html'

    character = RandomCharacter.get

    erb :email, locals: {
      image_url: character[:avatar_path],
      hero_heading: "#{character[:first_name]} #{character[:last_name]}",
      hero_text: "“#{character[:quote]}”",
    }
  end
end
