module Adapters
  module Storage
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
      end
    end
  end
end
