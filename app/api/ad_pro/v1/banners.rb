module AdPro
  module V1
    class Banners < Grape::API
      format :json

      helpers do
        def adapter
          Adapters::ActiveRecord::Banner.new
        end
      end

      desc 'Get list of banners.'
      get '/banners' do
        adapter.all
      end

      desc 'Get a given banners.'
      params { requires :id, type: Integer, desc: 'Banner id.' }
      get '/banners/:id' do
        adapter.get(params[:id])
      end

      desc 'Create a banner.'
      params do
        requires :name, type: String, desc: 'Banner name.'
        requires :url, type: String, desc: 'Banner url.'
      end
      post '/banners' do
        adapter.create(params[:name], params[:url])
      end

      desc 'Update a given campaign.'
      params do
        requires :name, type: String, desc: 'Banner name.'
        requires :url, type: String, desc: 'Banner url.'
        requires :id, type: Integer, desc: 'Banner id.'
      end
      put '/banners/:id' do
        adapter.update(params[:id], params[:name], params[:url])
      end
      patch '/banners/:id' do
        adapter.update(params[:id], params[:name], params[:url])
      end

      desc 'Delete given banner.'
      params { requires :id, type: Integer, desc: 'Banner id.' }
      delete '/banners/:id' do
        adapter.delete(params[:id])
      end
    end
  end
end
