module V1
  class CampaignsController < ApplicationController
    def index
      @campaigns = Campaign.all

      render json: @campaigns, status: :ok
    end

    def create
      if campaign_params[:name]
        @campaign = Campaign.new(campaign_params)
        @campaign.save

        render json: @campaign, status: :created
      else
        render json: { error: 'name is required' }, status: :bad_request
      end
    end

    private

    def campaign_params
      params.permit(:name)
    end
  end
end
