module AdPro
  class API < Grape::API
    mount V1::Campaigns
    mount V1::Banners
    mount V1::CampaignBanners
    mount V1::Ads
  end
end
