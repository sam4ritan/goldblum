class Goldblum
  class Quote
    def self.get
      quotes = YAML.load(File.new('./config/quotes.yml'))
      quotes.sample
    end
  end
end
