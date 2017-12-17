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
    end
  end
end
