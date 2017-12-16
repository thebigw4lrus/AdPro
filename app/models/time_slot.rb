class TimeSlot < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner
end
