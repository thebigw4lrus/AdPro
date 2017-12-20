module Adapters
  module ActiveRecord
    class Banner
      def all
        ::Banner.all
      end

      def get(id)
        ::Banner.find(id)
      end

      def create(name)
        banner = ::Banner.new(name: name)
        banner.save

        banner
      end

      def update(id, name, url)
        banner = ::Banner.find(id)
        banner.name = name
        banner.url = url
        banner.save

        banner
      end
    end
  end
end
