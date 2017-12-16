ActiveRecord::Schema.define(version: 20171216163546) do
  create_table 'banners', force: true do |t|
    t.string   'name'
    t.text     'url'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'campaigns', force: true do |t|
    t.string   'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'time_slots', force: true do |t|
    t.integer  'slot'
    t.integer  'campaign_id'
    t.integer  'banner_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'time_slots',
            ['banner_id'],
            name: 'index_time_slots_on_banner_id',
            using: :btree
  add_index 'time_slots',
            ['campaign_id'],
            name: 'index_time_slots_on_campaign_id',
            using: :btree
end
