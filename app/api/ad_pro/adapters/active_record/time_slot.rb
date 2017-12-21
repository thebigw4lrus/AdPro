module AdPro
  module Adapters
    module ActiveRecord
      class TimeSlot
        def create(slot, campaign_id, banner_id)
          banner = ::Banner.find(banner_id)
          campaign = ::Campaign.find(campaign_id)

          time_slot = ::TimeSlot.new(slot: slot,
                                     banner: banner,
                                     campaign: campaign)
          time_slot.save
          time_slot
        end

        def delete(slot, campaign_id, banner_id)
          time_slot = ::TimeSlot.find_by(slot: slot,
                                         banner_id: banner_id,
                                         campaign_id: campaign_id)
          time_slot.destroy
        end

        def banners_per_slot(time_slot)
          ::Banner.select(:'banners.id',
                          :'banners.name',
                          :'banners.url',
                          :'campaigns.id as campaign_id',
                          :'campaigns.name as campaign_name')
                  .joins(:time_slots)
                  .joins(:campaigns)
                  .where(time_slots: { slot: time_slot })
                  .map(&:as_json)
        end

        def banners_per_campaign(campaign_id)
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
