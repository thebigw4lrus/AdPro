module AdPro
  class API < Grape::API
    mount V1::Campaigns
  end
end
