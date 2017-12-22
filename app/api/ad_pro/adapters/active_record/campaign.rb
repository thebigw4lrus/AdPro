module AdPro
  module Adapters
    module ActiveRecord
      # Adapter that handles the Campaign entity
      # ==== Interface methods
      # * +all+ - Deliver a collection of campaigns
      # * +get+ - Deliver one single campaign
      # * +create+ - Creates a campaign
      # * +update+ - Update a campaign
      # * +delete+ - Deletes a campaign
      class Campaign

        # Get a list of campaigns
        # ==== output example
        #   # [
        #   #   {
        #   #     'id': 1,
        #   #     'name': 'campaign',
        #   #     'created_at': <date object>,
        #   #     'updated_at': <date object>
        #   #   }
        #   # ]
        def all
          ::Campaign.all.map(&:as_json)
        end

        # Get a list of campaigns
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'campaign',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def get(name)
          ::Campaign.find(name).as_json
        end

        # Get a list of campaigns
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'campaign',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def create(name, id = nil)
          campaign = ::Campaign.new(name: name, id: id)
          campaign.save

          campaign.as_json
        end

        # Get a list of campaigns
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'campaign',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def update(id, name)
          campaign = ::Campaign.find(id)
          campaign.name = name
          campaign.save

          campaign.as_json
        end

        # Get a list of campaigns
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'campaign',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def delete(id)
          campaign = ::Campaign.find(id)
          campaign.destroy.as_json
        end
      end
    end
  end
end
