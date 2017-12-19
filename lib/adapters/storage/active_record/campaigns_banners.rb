module Adapters
  module Storage
    module ActiveRecord
      class CampaignsBanners
        def get(campaign_id)
          campaign = ::Campaign.find(campaign_id)

          json = campaign.as_json
          json['banners'] = banners_with_time_slot(campaign.id)

          json
        end

        private

        def banners_with_time_slot(campaign_id)
          ::Banner.select(:'banners.id',
                          :'banners.name',
                          :'banners.url',
                          :'time_slots.slot as time_slot')
                  .joins(:time_slots)
                  .where(time_slots: { campaign_id: campaign_id })
                  .map(&:as_json)
        end
      end
    end
  end
end
