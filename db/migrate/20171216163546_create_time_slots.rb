class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.integer :slot
      t.references :campaign, index: true
      t.references :banner, index: true

      t.timestamps
    end
  end
end
