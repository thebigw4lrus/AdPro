module AdPro
  module V1
    class Ads < Grape::API
      format :json

      helpers do
        def adapter
          Adapters::ActiveRecord::Ads.new
        end
      end

      rescue_from ActiveRecord::RecordNotFound do
        error!('record not found', 404)
      end

      rescue_from ActiveRecord::RecordNotUnique do
        error!('this record already exists', 409)
      end

      desc 'Get all ads in a given time slot'
      get '/ads/:slot' do
        adapter.get(params[:slot])
      end
    end
  end
end