module AdPro
  class API < Grape::API
    mount V1::Campaigns
    mount V1::Banners
  end
end
