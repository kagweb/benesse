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

ActiveRecord::Schema.define(:version => 20130818215602) do

  create_table "branches", :force => true do |t|
    t.integer  "project_id", :null => false
    t.string   "code",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "parties", :force => true do |t|
    t.integer  "project_id",                      :null => false
    t.integer  "user_id",                         :null => false
    t.boolean  "required",     :default => false, :null => false
    t.boolean  "mail_send_to", :default => false, :null => false
    t.boolean  "mail_send_cc", :default => false, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "code",                                     :null => false
    t.string   "name",                                     :null => false
    t.integer  "authorizer_id",                            :null => false
    t.integer  "promoter_id",                              :null => false
    t.integer  "operator_id",                              :null => false
    t.integer  "status",                :default => 0,     :null => false
    t.boolean  "confirmed",             :default => false, :null => false
    t.string   "upload_url",                               :null => false
    t.string   "production_upload_url"
    t.datetime "test_upload_at"
    t.datetime "production_upload_at"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",         :null => false
    t.string   "email",            :null => false
    t.string   "crypted_password", :null => false
    t.string   "salt",             :null => false
    t.integer  "department_id",    :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
