class Goldblum
  class PrintJSON
    include Sidekiq::Worker

    def perform(json)
      puts JSON.pretty_generate(json)
    end
  end
end
