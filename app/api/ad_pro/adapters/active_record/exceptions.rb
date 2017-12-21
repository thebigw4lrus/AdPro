module AdPro
  module Adapters
    module ActiveRecord
      class Exceptions
        RECORD_NOT_FOUND = ::ActiveRecord::RecordNotFound
        RECORD_NOT_UNIQUE = ::ActiveRecord::RecordNotUnique
      end
    end
  end
end
