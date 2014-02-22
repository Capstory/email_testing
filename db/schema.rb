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

ActiveRecord::Schema.define(:version => 20140222034942) do

  create_table "access_requests", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "event_address"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.date     "event_date"
    t.string   "request_status"
    t.string   "source"
    t.string   "partner_code"
    t.string   "industry_role"
    t.text     "questions"
  end

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  create_table "capsules", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "email"
    t.date     "event_date"
    t.string   "named_url"
    t.text     "response_message"
    t.string   "pin_code"
  end

  create_table "charges", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "customer_hash"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "error_hash"
  end

  create_table "encapsulations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.boolean  "owner"
    t.boolean  "guest"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "entries", :force => true do |t|
    t.string   "name"
    t.boolean  "winner"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "identities", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "genre"
    t.date     "event_date"
    t.integer  "user_id"
  end

  create_table "posts", :force => true do |t|
    t.text     "body"
    t.string   "email"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "capsule_id"
    t.string   "filepicker_url"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  create_table "vendor_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "vendor_code"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "phone"
    t.text     "message"
    t.integer  "vendor_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.string   "partner_code"
    t.string   "email"
    t.string   "phone"
    t.string   "named_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "zencoder_url"
    t.integer  "post_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "video"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
  end

end
