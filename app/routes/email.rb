class Goldblum < Sinatra::Base
  get '/email' do
    content_type 'text/html'

    erb :email, locals: {
      image_url: 'avatars/ianmalcolm/004.jpg',
      hero_heading: 'Ian Malcolm',
      hero_text: '“Your scientists were so preoccupied with whether or not they could, they didn’t stop to think if they should.”',
    }
  end
end
