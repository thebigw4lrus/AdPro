require 'net/http'
require 'uri'

module AdPro
  class IpToTime
    DATETIME_PATH = %w[data datetime date_time_ymd].freeze
    DECODE_PATTERN = '%Y-%m-%dT%H:%M:%S'.freeze


    def initialize(ip, path)
      @path = path + '?' + ip
    end

    def get
      if response&.code == '200'
        json = JSON.parse(response.body)
        DateTime.strptime(json.dig(*DATETIME_PATH), DECODE_PATTERN)
      else
        DateTime.now
      end
    end

    private

    def response
      uri = ::URI.parse(@path)
      @response ||= Net::HTTP.get_response(uri)
    end
  end
end
