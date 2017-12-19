module Adapters
  module Storage
    module ActiveRecord
      class Ads
        def get(time_slot)
          {
            'banners' => banners_per_slot(time_slot)
          }
        end

        private

        def banners_per_slot(time_slot)
          ::Banner.select(:'banners.id',
                          :'banners.name',
                          :'banners.url')
                  .joins(:time_slots)
                  .where(time_slots: { slot: time_slot })
                  .map(&:as_json)
        end
      end
    end
  end
end
