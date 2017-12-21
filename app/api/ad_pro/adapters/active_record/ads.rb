module AdPro
  module Adapters
    module ActiveRecord
      class Ads
        def initialize(time_slot_adapter)
          @time_slot_adapter = time_slot_adapter
        end

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
