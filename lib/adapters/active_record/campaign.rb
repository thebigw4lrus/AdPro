module Adapters
  module ActiveRecord
    class Campaign
      def all
        ::Campaign.all
      end

      def get(name)
        ::Campaign.find(name)
      end

      def create(name)
        campaign = ::Campaign.new(name: name)
        campaign.save

        campaign
      end

      def update(id, name)
        campaign = ::Campaign.find(id)
        campaign.name = name
        campaign.save

        campaign
      end
    end
  end
end
