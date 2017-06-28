class Goldblum
  class RandomCharacter
    def self.get
      characters    = YAML.load(File.new('./config/characters.yml'))
      character     = characters.sample
      avatar_number = rand(1..character[:avatar_count])

      {
        first_name:  character[:first_name],
        last_name:   character[:last_name],
        quote:       character[:quotes].sample,
        avatar_path: "avatars/#{character[:avatar_path]}/#{sprintf("%03d", avatar_number)}.jpg"
      }
    end
  end
end
