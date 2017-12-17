module AdPro
  class API < Grape::API
    format :json

    rescue_from ActiveRecord::RecordNotFound do
      error!('record not found', 404)
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
  end
end
