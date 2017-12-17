class Campaign < ActiveRecord::Base
  has_many :time_slots
  has_many :banners, through: :time_slots

  validates :name, presence: true
end
