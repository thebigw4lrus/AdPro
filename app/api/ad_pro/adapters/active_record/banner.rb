module AdPro
  module Adapters
    module ActiveRecord
      class Banner
        def all
          ::Banner.all.map(&:as_json)
        end

        def get(id)
          ::Banner.find(id).as_json
        end

        def create(name, url, id = nil)
          banner = ::Banner.new(name: name,
                                url: url,
                                id: id)
          banner.save

          banner.as_json
        end

        def update(id, name, url)
          banner = ::Banner.find(id)
          banner.name = name
          banner.url = url
          banner.save

          banner.as_json
        end
      end
    end
  end
end
