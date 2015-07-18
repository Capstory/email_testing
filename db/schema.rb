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

ActiveRecord::Schema.define(:version => 20150718021852) do

  create_table "album_orders", :force => true do |t|
    t.float    "total"
    t.text     "address"
    t.text     "quantities"
    t.string   "name"
    t.string   "email"
    t.text     "contents"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.text     "customer_info"
    t.boolean  "paid"
    t.string   "status"
    t.string   "cover_photo_file_name"
    t.string   "cover_photo_content_type"
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.string   "inner_file_file_name"
    t.string   "inner_file_content_type"
    t.integer  "inner_file_file_size"
    t.datetime "inner_file_updated_at"
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
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "email"
    t.date     "event_date"
    t.string   "named_url"
    t.text     "response_message"
    t.string   "pin_code"
    t.text     "time_group"
    t.string   "page_title"
    t.boolean  "locked"
    t.boolean  "requires_verification", :default => false
    t.text     "styles"
    t.string   "template_url"
  end

  create_table "charges", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "customer_hash"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "error_hash"
    t.boolean  "is_test",       :default => false
  end

  create_table "contact_forms", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "source"
  end

  create_table "discounts", :force => true do |t|
    t.string   "discount_code"
    t.float    "amount"
    t.string   "genre"
    t.string   "campaign_name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "download_managers", :force => true do |t|
    t.text     "file_path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "encapsulations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "capsule_id"
    t.boolean  "owner"
    t.boolean  "guest"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_applications", :force => true do |t|
    t.string   "name"
    t.boolean  "student",             :default => true
    t.string   "university_year"
    t.string   "language_preference"
    t.string   "work_preference"
    t.string   "github_account_name"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.text     "message"
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

  create_table "logos", :force => true do |t|
    t.string   "image"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "logoable_id"
    t.string   "logoable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "height"
    t.integer  "width"
    t.integer  "padding_top"
    t.integer  "padding_left"
  end

  create_table "page_visits", :force => true do |t|
    t.string   "remote_ip"
    t.string   "original_url"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "posts", :force => true do |t|
    t.text     "body"
    t.string   "email"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "image"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "capsule_id"
    t.string   "filepicker_url"
    t.string   "time_group"
    t.boolean  "tag_for_deletion",     :default => false
    t.boolean  "verified",             :default => true
    t.boolean  "included_in_template", :default => false
  end

  create_table "test_program_visits", :force => true do |t|
    t.string   "ip_address"
    t.string   "test_version"
    t.boolean  "phaseline_one"
    t.boolean  "phaseline_two"
    t.boolean  "phaseline_three"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.integer  "vendor_id"
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
