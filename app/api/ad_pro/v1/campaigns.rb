module AdPro
  module V1
    class Campaigns < Grape::API
      format :json

      helpers do
        def campaign
          Adapters::ActiveRecord::Campaign.new
        end
      end

      rescue_from ActiveRecord::RecordNotFound do
        error!('record not found', 404)
      end

      rescue_from ActiveRecord::RecordNotUnique do
        error!('this record already exists', 409)
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
    end
  end
end
