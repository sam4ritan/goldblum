class Goldblum
  class Avatar
    def self.get
      avatar_number = rand(1..Goldblum.settings.avatar_count)
      "public/avatars/#{sprintf("%03d", avatar_number)}.jpg"
    end
  end
end
