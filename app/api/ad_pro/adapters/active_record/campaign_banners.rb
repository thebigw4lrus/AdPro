module AdPro
  module Adapters
    module ActiveRecord
      # Adapter that handles the campaign - banners relationship
      # This will be the one for setting up a campaign
      # ==== Interface methods
      # * +get+ - Deliver one single campaign with banners
      # * +upsert+ - Insert / Update a campaign with banners
      class CampaignBanners
        # Assigns TimeSlot adapter
        # This instance will be used
        # to operate all about TimeSlot
        # === TimeSlot Interface methods
        # * +banners_per_campaign+ - Get banners per campaign
        # * +create+ - create a timeslot banner/campaign
        # * +delete+ - delete  timeslot banner/campaign
        def initialize(time_slot_adapter)
          @slot_adapter = time_slot_adapter
        end

        # Get a campign with banners
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'campaign',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   #   'banners': [
        #   #       {
        #   #         'id': 1,
        #   #         'name': 'banner_name',
        #   #         'time_slot': '15',
        #   #         'url': 'banner_url'
        #   #       }
        #   #    ]
        #   # }
        def get(campaign_id)
          campaign = ::Campaign.find(campaign_id)

          json = campaign.as_json
          json['banners'] = @slot_adapter.banners_per_campaign(campaign.id)

          json
        end

        # Update/Insert a campign with banners
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'campaign',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   #   'banners': [
        #   #       {
        #   #         'id': 1,
        #   #         'name': 'banner_name',
        #   #         'time_slot': '15',
        #   #         'url': 'banner_url'
        #   #       }
        #   #    ]
        #   # }
        def upsert(campaign_id, banners)
          existent_set = calculate_existent_slot_set(campaign_id)
          new_set = calculate_new_slot_set(campaign_id, banners)

          slots_to_create = new_set - existent_set
          slots_to_delete = existent_set - new_set

          ::TimeSlot.transaction do
            slots_to_create.each { |slot| @slot_adapter.create(*slot) }
            slots_to_delete.each { |slot| @slot_adapter.delete(*slot) }
          end

          get(campaign_id)
        end

        private

        def calculate_existent_slot_set(campaign_id)
          @slot_adapter.slots_per_campaign(campaign_id) do |record|
            [record.slot, record.campaign_id, record.banner_id]
          end
        end

        def calculate_new_slot_set(campaign_id, banners)
          banners.map do |record|
            [record['time_slot'], campaign_id, record['banner_id']]
          end
        end
      end
    end
  end
end
