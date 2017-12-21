module AdPro
  module V1
    class CampaignBanners < Grape::API
      format :json

      helpers do
        def adapter
          slot_adapter = Adapters::ActiveRecord::TimeSlot.new
          Adapters::ActiveRecord::CampaignBanners.new(slot_adapter)
        end
      end

      desc 'Get all banners bound to a campaign'
      get '/campaigns/:id/banners' do
        adapter.get(params[:id])
      end

      desc 'create assignation banners to a campaign'
      params do
        requires :id, type: Integer, desc: 'Campaign Id.'
        optional :banners, type: Array, default: [], desc: 'Campaign id.' do
          requires :banner_id, type: Integer, desc: 'Banner Id.'
          requires :time_slot,
                   type: Integer,
                   values: 0..23,
                   desc: 'Banner Time Slot.'
        end
      end
      put('/campaigns/:id/banners') do
        adapter.upsert(params[:id], params[:banners])
      end
    end
  end
end
