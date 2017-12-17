module AdPro
  class API < Grape::API
    format :json

    rescue_from ActiveRecord::RecordNotFound do
      error!('record not found', 404)
    end

    resource :campaigns do
      desc 'Get list of Campaigns.'
      get { ::Campaign.all }

      desc 'Get a given campaign.'
      params { requires :id, type: Integer, desc: 'Campaign id.' }
      route_param :id do
        get { ::Campaign.find(params[:id]) }
      end

      desc 'Create a campaign.'
      params { requires :name, type: String, desc: 'Campaign name.' }
      post do
        campaign = ::Campaign.new(name: params[:name])
        campaign.save

        campaign
      end

      desc 'Update a given campaign.'
      params do
        requires :name, type: String, desc: 'Campaign name.'
        requires :id, type: Integer, desc: 'Campaign id.'
      end
      route_param :id do
        update_campaign = proc do |params|
          campaign = ::Campaign.find(params[:id])
          campaign.name = params[:name]

          campaign
        end

        put { update_campaign.call(params) }
        patch { update_campaign.call(params) }
      end
    end

    resource :banners do
      desc 'Get list of banners.'
      get { ::Banner.all }

      desc 'Get a given banners.'
      params { requires :id, type: Integer, desc: 'Banner id.' }
      route_param :id do
        get { ::Banner.find(params[:id]) }
      end

      desc 'Create a banner.'
      params do
        requires :name, type: String, desc: 'Banner name.'
        requires :url, type: String, desc: 'Banner url.'
      end
      post do
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
      route_param :id do
        update_banner = proc do |params|
          banner = ::Banner.find(params[:id])
          banner.name = params[:name]
          banner.url = params[:url]

          banner
        end

        put { update_banner.call(params) }
        patch { update_banner.call(params) }
      end
    end
  end
end
