module AdPro
  module Adapters
    module ActiveRecord
      # Adapter that handles the Banner identity
      # ==== Interface methods
      # * +all+ - Deliver a collection of banners
      # * +get+ - Deliver one single banner
      # * +create+ - Creates a banner
      # * +update+ - Update a banner
      # * +delete+ - Deletes a banner
      class Banner
        # Get a list of banners
        # ==== output example
        #   # [
        #   #   {
        #   #     'id': 1,
        #   #     'name': 'banner',
        #   #     'url': 'someurl',
        #   #     'created_at': <date object>,
        #   #     'updated_at': <date object>
        #   #   }
        #   # ]
        def all
          ::Banner.all.map(&:as_json)
        end

        # Get a banner
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'banner',
        #   #   'url': 'someurl',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def get(id)
          ::Banner.find(id).as_json
        end

        # Creates a banner
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'banner',
        #   #   'url': 'someurl',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def create(name, url, id = nil)
          banner = ::Banner.new(name: name,
                                url: url,
                                id: id)
          banner.save

          banner.as_json
        end

        # Updates a banner
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'banner',
        #   #   'url': 'someurl',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def update(id, name, url)
          banner = ::Banner.find(id)
          banner.name = name
          banner.url = url
          banner.save

          banner.as_json
        end

        # Deletes a banner
        # ==== output example
        #   # {
        #   #   'id': 1,
        #   #   'name': 'banner',
        #   #   'url': 'someurl',
        #   #   'created_at': <date object>,
        #   #   'updated_at': <date object>
        #   # }
        def delete(id)
          banner = ::Banner.find(id)
          banner.destroy.as_json
        end
      end
    end
  end
end
