module AdPro
  module Adapters
    module ActiveRecord
      class Campaign
        def all
          ::Campaign.all.map(&:as_json)
        end

        def get(name)
          ::Campaign.find(name).as_json
        end

        def create(name, id = nil)
          campaign = ::Campaign.new(name: name, id: id)
          campaign.save

          campaign.as_json
        end

        def update(id, name)
          campaign = ::Campaign.find(id)
          campaign.name = name
          campaign.save

          campaign.as_json
        end

        def delete(id)
          campaign = ::Campaign.find(id)
          campaign.destroy.as_json
        end
      end
    end
  end
end
