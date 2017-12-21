module AdPro
  module V1
    class Campaigns < Grape::API
      format :json

      helpers do
        def adapter
          Adapters::ActiveRecord::Campaign.new
        end
      end

      namespace :v1 do
        desc 'Get list of Campaigns.'
        get '/campaigns' do
          adapter.all
        end

        desc 'Get a given campaign.'
        params { requires :id, type: Integer, desc: 'Campaign id.' }
        get '/campaigns/:id' do
          adapter.get(params[:id])
        end

        desc 'Create a campaign.'
        params { requires :name, type: String, desc: 'Campaign name.' }
        post '/campaigns' do
          adapter.create(params[:name])
        end

        desc 'Update a given campaign.'
        params do
          requires :name, type: String, desc: 'Campaign name.'
          requires :id, type: Integer, desc: 'Campaign id.'
        end
        put '/campaigns/:id' do
          adapter.update(params[:id], params[:name])
        end
        patch '/campaigns/:id' do
          adapter.update(params[:id], params[:name])
        end

        desc 'Delete given campaign.'
        params { requires :id, type: Integer, desc: 'Campaign id.' }
        delete '/campaigns/:id' do
          adapter.delete(params[:id])
        end
      end
    end
  end
end
