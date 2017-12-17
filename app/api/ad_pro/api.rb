module AdPro
  class API < Grape::API
    format :json

    rescue_from ActiveRecord::RecordNotFound do
      error!('record not found', 404)
    end

    rescue_from ActiveRecord::RecordNotUnique do
      error!('this record already exists', 409)
    end

    desc 'Get list of Campaigns.'
    get '/campaigns' do
      ::Campaign.all
    end

    desc 'Get a given campaign.'
    params { requires :id, type: Integer, desc: 'Campaign id.' }
    get '/campaigns/:id' do
      ::Campaign.find(params[:id])
    end

    desc 'Create a campaign.'
    params { requires :name, type: String, desc: 'Campaign name.' }
    post '/campaigns' do
      campaign = ::Campaign.new(name: params[:name])
      campaign.save

      campaign
    end

    desc 'Update a given campaign.'
    params do
      requires :name, type: String, desc: 'Campaign name.'
      requires :id, type: Integer, desc: 'Campaign id.'
    end
    put '/campaigns/:id' do
      campaign = ::Campaign.find(params[:id])
      campaign.name = params[:name]

      campaign
    end
    patch '/campaigns/:id' do
      campaign = ::Campaign.find(params[:id])
      campaign.name = params[:name]

      campaign
    end

    desc 'Get list of banners.'
    get '/banners' do
      ::Banner.all
    end

    desc 'Get a given banners.'
    params { requires :id, type: Integer, desc: 'Banner id.' }
    get '/banners/:id' do
      ::Banner.find(params[:id])
    end

    desc 'Create a banner.'
    params do
      requires :name, type: String, desc: 'Banner name.'
      requires :url, type: String, desc: 'Banner url.'
    end
    post '/banners' do
      banner = ::Banner.new(name: params[:name], url: params[:url])
      banner.save

      banner
    end

    desc 'Update a given campaign.'
    params do
      requires :name, type: String, desc: 'Banner name.'
      requires :url, type: String, desc: 'Banner url.'
      requires :id, type: Integer, desc: 'Banner id.'
    end
    put '/banners/:id' do
      banner = ::Banner.find(params[:id])
      banner.name = params[:name]
      banner.url = params[:url]
      banner.save

      banner
    end
    patch '/banners/:id' do
      banner = ::Banner.find(params[:id])
      banner.name = params[:name]
      banner.url = params[:url]
      banner.save

      banner
    end

    desc 'Create a Time Slot.'
    params do
      requires :campaign_id, type: Integer, desc: 'Campaign Id.'
      requires :banner_id, type: Integer, desc: 'Banner Id.'
      requires :slot, type: Integer, desc: 'Display Hour of the banner'
    end
    post '/campaigns/:campaign_id/banners/:banner_id/time_slots/:slot' do
      banner = ::Banner.find(params[:banner_id])
      campaign = ::Campaign.find(params[:campaign_id])

      time_slot = TimeSlot.new(slot: params[:slot],
                               banner: banner,
                               campaign: campaign)

      time_slot.save

      time_slot
    end

    desc 'Delete a Time Slot.'
    params do
      requires :campaign_id, type: Integer, desc: 'Campaign Id.'
      requires :banner_id, type: Integer, desc: 'Banner Id.'
      requires :slot, type: Integer, desc: 'Display Hour of the banner'
    end
    delete '/campaigns/:campaign_id/banners/:banner_id/time_slots/:slot' do
      time_slot = TimeSlot.find_by(slot: params[:slot],
                                   banner_id: params[:banner_id],
                                   campaign_id: params[:campaign_id])
      time_slot.destroy
    end
  end
end
