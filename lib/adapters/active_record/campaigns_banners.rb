module Adapters
  module ActiveRecord
    class CampaignsBanners
      def initialize(time_slot_adapter)
        @slot_adapter = time_slot_adapter
      end

      def get(campaign_id)
        campaign = ::Campaign.find(campaign_id)

        json = campaign.as_json
        json['banners'] = banners_with_time_slot(campaign.id)

        json
      end

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
        ::TimeSlot.where(campaign_id: campaign_id).map do |record|
          [record.slot, record.campaign_id, record.banner_id]
        end
      end

      def calculate_new_slot_set(campaign_id, banners)
        banners.map do |record|
          [record['time_slot'], campaign_id, record['banner_id']]
        end
      end

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
