module AdPro
  module V1
    class Ads < Grape::API
      format :json

      helpers do
        def adapter
          time_slot_adapter = Adapters::ActiveRecord::TimeSlot.new
          Adapters::ActiveRecord::Ads.new(time_slot_adapter)
        end

        def ip_to_time
          ip = request.env['REMOTE_ADDR']
          path = Rails.application.config.ip_to_time_server
          date_time = IpToTime.new(ip, path).get

          date_time.hour
        end
      end

      desc 'Get all ads in a time slot taken from remote'
      get '/ads/' do
        adapter.get(ip_to_time)
      end
    end
  end
end
