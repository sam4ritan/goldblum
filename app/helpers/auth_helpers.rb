# TODO: better auth somehow
class Goldblum < Sinatra::Base
  module AuthHelpers
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      status 401
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'p00p00p00']
    end
  end

  helpers AuthHelpers
end
