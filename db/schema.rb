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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120902122046) do

  create_table "accounts", :force => true do |t|
    t.string   "type"
    t.string   "url"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "contact_account_id"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name"
    t.string   "company"
    t.string   "tel_1"
    t.string   "tel_2"
    t.string   "email"
    t.string   "url"
    t.string   "birthday"
    t.string   "street"
    t.string   "plz"
    t.string   "city"
    t.string   "country"
    t.text     "social"
    t.text     "picture"
    t.text     "notes"
    t.string   "tags"
    t.string   "source"
    t.text     "raw_card"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "contacts", ["uid"], :name => "index_contacts_on_uid", :unique => true

  create_table "events", :force => true do |t|
    t.integer  "event_account_id"
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",          :default => false
    t.string   "color"
    t.text     "raw_card"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

end
