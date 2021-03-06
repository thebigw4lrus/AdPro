# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171217180808) do

  create_table "banners", force: true do |t|
    t.string   "name"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_slots", force: true do |t|
    t.integer  "slot"
    t.integer  "campaign_id"
    t.integer  "banner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_slots", ["banner_id"], name: "index_time_slots_on_banner_id", using: :btree
  add_index "time_slots", ["campaign_id"], name: "index_time_slots_on_campaign_id", using: :btree
  add_index "time_slots", ["slot", "campaign_id", "banner_id"], name: "index_time_slots_on_slot_and_campaign_id_and_banner_id", unique: true, using: :btree

end
