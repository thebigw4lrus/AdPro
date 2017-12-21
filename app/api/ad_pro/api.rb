module AdPro
  class API < Grape::API
    rescue_from Adapters::ActiveRecord::Exceptions::RECORD_NOT_FOUND do
      error!('record not found', 404)
    end

    rescue_from Adapters::ActiveRecord::Exceptions::RECORD_NOT_UNIQUE do
      error!('this record already exists', 409)
    end

    mount V1::Campaigns
    mount V1::Banners
    mount V1::CampaignBanners
    mount V1::Ads
  end
end
