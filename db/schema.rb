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

ActiveRecord::Schema.define(:version => 20130531194536) do

  create_table "card_entries", :force => true do |t|
    t.string   "card_id",    :limit => nil, :null => false
    t.text     "access",                    :null => false
    t.integer  "github_id",  :limit => 8
    t.text     "key"
    t.text     "value"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "card_entries", ["card_id", "access", "github_id", "key"], :name => "index_card_entries_on_card_id_and_access_and_github_id_and_key", :unique => true

  create_table "page_templates", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "page_templates", ["key"], :name => "index_page_templates_on_key", :unique => true

  create_table "users", :id => false, :force => true do |t|
    t.integer  "github_id",           :limit => 8, :null => false
    t.text     "github_access_token"
    t.text     "github_login"
    t.text     "name"
    t.text     "email"
    t.text     "gravatar_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

end
