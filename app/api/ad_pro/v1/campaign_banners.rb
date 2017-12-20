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

      rescue_from ActiveRecord::RecordNotFound do
        error!('record not found', 404)
      end

      rescue_from ActiveRecord::RecordNotUnique do
        error!('this record already exists', 409)
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
          requires :time_slot, type: Integer, desc: 'Banner Time Slot.'
        end
      end
      put('/campaigns/:id/banners') do
        adapter.upsert(params[:id], params[:banners])
      end
    end
  end
end
