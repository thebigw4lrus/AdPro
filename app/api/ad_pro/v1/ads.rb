module AdPro
  module V1
    class Ads < Grape::API
      format :json

      helpers do
        def adapter
          time_slot_adapter = Adapters::ActiveRecord::TimeSlot.new
          Adapters::ActiveRecord::Ads.new(time_slot_adapter)
        end
      end

      desc 'Get all ads in a given time slot'
      params do
        requires :slot, type: Integer, values: 0..23, desc: 'Time Slot for ads.'
      end
      get '/ads/:slot' do
        adapter.get(params[:slot])
      end
    end
  end
end
