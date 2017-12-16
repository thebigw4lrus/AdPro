class Banner < ActiveRecord::Base
  has_many :time_slots
  has_many :campaigns, :through :time_slots  
end
