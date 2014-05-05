module Colibri
  module UserApiAuthentication
    def generate_colibri_api_key!
      self.colibri_api_key = SecureRandom.hex(24)
      save!
    end

    def clear_colibri_api_key!
      self.colibri_api_key = nil
      save!
    end
  end
end
