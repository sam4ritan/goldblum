class Goldblum
  class Character
    def self.get
      characters = YAML.load(File.new('./config/characters.yml'))
      characters.sample
    end
  end
end
