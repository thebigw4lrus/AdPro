module AdPro
  class API < Grape::API
    format :json

    helpers do
      def campaign
        ::Adapters::Storage::ActiveRecord::Campaign.new
      end

      def banner
        ::Adapters::Storage::ActiveRecord::Banner.new
      end

      def time_slot
        ::Adapters::Storage::ActiveRecord::TimeSlot.new
      end

      def campaigns_banners
        slot_adapter = ::Adapters::Storage::ActiveRecord::TimeSlot.new
        ::Adapters::Storage::ActiveRecord::CampaignsBanners.new(slot_adapter)
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
      campaigns_banners.get(params[:id])
    end

    desc 'create assignation banners to a campaign'
    params do
      requires :id, type: Integer, desc: 'Campaign Id.'
      requires :banners, type: Array, desc: 'Campaign id.' do
        requires :banner_id, type: Integer, desc: 'Banner Id.'
        requires :time_slot, type: Integer, desc: 'Banner Time Slot.'
      end
    end
    post('/campaigns/:id/banners') do
      campaigns_banners.upsert(params[:id], params[:banners])
    end

    desc 'Get list of Campaigns.'
    get '/campaigns' do
      campaign.all
    end

    desc 'Get a given campaign.'
    params { requires :id, type: Integer, desc: 'Campaign id.' }
    get '/campaigns/:id' do
      campaign.get(params[:id])
    end

    desc 'Create a campaign.'
    params { requires :name, type: String, desc: 'Campaign name.' }
    post '/campaigns' do
      campaign.create(params[:name])
    end

    desc 'Update a given campaign.'
    params do
      requires :name, type: String, desc: 'Campaign name.'
      requires :id, type: Integer, desc: 'Campaign id.'
    end
    put '/campaigns/:id' do
      campaign.update(params[:id], params[:name])
    end
    patch '/campaigns/:id' do
      campaign.update(params[:id], params[:name])
    end

    desc 'Get list of banners.'
    get '/banners' do
      banner.all
    end

    desc 'Get a given banners.'
    params { requires :id, type: Integer, desc: 'Banner id.' }
    get '/banners/:id' do
      banner.get(params[:id])
    end

    desc 'Create a banner.'
    params do
      requires :name, type: String, desc: 'Banner name.'
      requires :url, type: String, desc: 'Banner url.'
    end
    post '/banners' do
      banner.create(params[:name])
    end

    desc 'Update a given campaign.'
    params do
      requires :name, type: String, desc: 'Banner name.'
      requires :url, type: String, desc: 'Banner url.'
      requires :id, type: Integer, desc: 'Banner id.'
    end
    put '/banners/:id' do
      banner.update(params[:id], params[:name], params[:url])
    end
    patch '/banners/:id' do
      banner.update(params[:id], params[:name], params[:url])
    end

    desc 'Create a Time Slot.'
    params do
      requires :campaign_id, type: Integer, desc: 'Campaign Id.'
      requires :banner_id, type: Integer, desc: 'Banner Id.'
      requires :slot, type: Integer, desc: 'Display Hour of the banner'
    end
    post '/campaigns/:campaign_id/banners/:banner_id/time_slots/:slot' do
      time_slot.create(params[:slot], params[:campaign_id], params[:banner_id])
    end

    desc 'Delete a Time Slot.'
    params do
      requires :campaign_id, type: Integer, desc: 'Campaign Id.'
      requires :banner_id, type: Integer, desc: 'Banner Id.'
      requires :slot, type: Integer, desc: 'Display Hour of the banner'
    end
    delete '/campaigns/:campaign_id/banners/:banner_id/time_slots/:slot' do
      time_slot.delete(params[:slot], params[:campaign_id], params[:banner_id])
    end
  end
end
