class TimeSlotIndex < ActiveRecord::Migration
  def change
    add_index :time_slots, %i[slot campaign_id banner_id], unique: true
  end
end
