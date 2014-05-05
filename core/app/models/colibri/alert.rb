require 'httparty'

module Colibri
  class Alert
    def self.current(host)
      params = {
        version: Colibri.version,
        name: Colibri::Store.current.name,
        host: host,
        rails_env: Rails.env,
        rails_version: Rails.version
      }

      HTTParty.get('http://alerts.colibricommerce.com/alerts.json', query: params).parsed_response
    end
  end
end
