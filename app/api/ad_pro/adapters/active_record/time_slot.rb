module AdPro
  module Adapters
    module ActiveRecord
      # Adapter that handles Time Slots
      # no open interface, but this is used
      # by others adapters
      class TimeSlot
        # Creates a time slot
        # ==== Input
        # * +slot+ - timeslot (0..23)
        # * +campaign_id+ - Id of the campaign
        # * +banner_id+ - Id of the banner
        # ==== Output
        # * +<time_slot>+ - instance of TimeSlot object
        def create(slot, campaign_id, banner_id)
          banner = ::Banner.find(banner_id)
          campaign = ::Campaign.find(campaign_id)

          time_slot = ::TimeSlot.new(slot: slot,
                                     banner: banner,
                                     campaign: campaign)
          time_slot.save
          time_slot
        end

        # Deletes a time slot
        # ==== Input
        # * +slot+ - timeslot (0..23)
        # * +campaign_id+ - Id of the campaign
        # * +banner_id+ - Id of the banner
        # ==== Output
        # * +<time_slot>+ - instance of TimeSlot object
        def delete(slot, campaign_id, banner_id)
          time_slot = ::TimeSlot.find_by(slot: slot,
                                         banner_id: banner_id,
                                         campaign_id: campaign_id)
          time_slot.destroy
        end

        # Retreives all timeslots per campaign
        # output format can be provided via block
        # ==== Input
        # * +campaign_id+ - Id of the campaign
        # ==== Output
        # * +[<time_slot>]+ - Array of Representation of the time slots
        def slots_per_campaign(campaign_id)
          ::TimeSlot.where(campaign_id: campaign_id).map do |record|
            yield record
          end
        end

        # Retreives all banners per time slot
        # ==== Input
        # * +time_slot+ - Time Slot to look up (0..23)
        # ==== Output
        # * +[<banners>]+ - Array of Representation of banners
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

        # Retreives all banners per campaign
        # output format can be provided via block
        # ==== Input
        # * +campaign_id+ - ID of the campaign
        # ==== Output
        # * +[<banners>]+ - Array of Representation of banners
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
