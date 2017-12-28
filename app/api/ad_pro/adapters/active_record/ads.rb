module AdPro
  module Adapters
    module ActiveRecord
      # Adapter that handles the Ads entity
      # This only retrieves a set of banners
      # with its campaign given a timeslot
      # ==== Interface methods
      # * +get+ - Deliver ads enriched with campaign info
      class Ads
        # Assigns TimeSlot adapter
        # This instance will be used
        # to operate all about TimeSlot
        # === TimeSlot Interface methods
        # * +banners_per_slot+ - Get banners per time slot
        def initialize(time_slot_adapter)
          @time_slot_adapter = time_slot_adapter
        end

        # Get Ads(banners) enriched with campaign info
        # ==== output example
        #   # {
        #   #   'banners': [
        #   #       {
        #   #         'id': 1,
        #   #         'name': 'banner_name',
        #   #         'time_slot': '15',
        #   #         'url': 'banner_url',
        #   #         'campaign_id': 5,
        #   #         'campaign_name': 'some_campaign'
        #   #       }
        #   #    ]
        #   # }
        def get(time_slot)
          {
            'time_slot' => time_slot,
            'banners' => @time_slot_adapter.banners_per_slot(time_slot)
          }
        end
      end
    end
  end
end
