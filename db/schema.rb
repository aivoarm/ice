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

ActiveRecord::Schema.define(version: 20140508193334) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "countries", force: true do |t|
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_headers", force: true do |t|
    t.integer  "line_num"
    t.string   "RECORD_TYPE"
    t.integer  "FILE_DATE"
    t.string   "SOURCE"
    t.integer  "INVOICE_COUNT"
    t.decimal  "INVOICE_AMOUNT"
    t.string   "TAX_VALIDATED"
    t.boolean  "valid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filetypes", force: true do |t|
    t.string   "ftype"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_details", force: true do |t|
    t.integer  "line_num"
    t.string   "RECORD_TYPE"
    t.integer  "FILE_DATE"
    t.string   "VENDOR_NUMBER"
    t.string   "PROVINCE_TAX_CODE"
    t.string   "INVOICE_NUMBER"
    t.decimal  "ITEM_AMOUNT"
    t.decimal  "GST_AMOUNT"
    t.decimal  "PST_AMOUNT"
    t.string   "COST_CENTER_SEGMENT"
    t.string   "ACCOUNT_SEGMENT"
    t.string   "SUB_ACCOUNT_SEGMENT"
    t.string   "SOURCE"
    t.string   "FILLER"
    t.boolean  "valid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_headers", force: true do |t|
    t.integer  "line_num"
    t.string   "RECORD_TYPE"
    t.integer  "FILE_DATE"
    t.string   "VENDOR_NUMBER"
    t.string   "PROVINCE_TAX_CODE"
    t.string   "CURRENCY_CODE"
    t.string   "INVOICE_NUMBER"
    t.integer  "INVOICE_DATE"
    t.decimal  "INVOICE_AMOUNT"
    t.decimal  "ITEM_AMOUNT"
    t.decimal  "GST_AMOUNT"
    t.decimal  "PST_AMOUNT"
    t.string   "COMPANY_CODE_SEGMENT"
    t.string   "TAX_VALIDATED"
    t.string   "VENDOR_SITE_CODE"
    t.string   "SOURCE"
    t.boolean  "valid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layout_files", force: true do |t|
    t.string   "filepath"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layouts", force: true do |t|
    t.string   "description"
    t.integer  "start"
    t.integer  "length"
    t.string   "ftype"
    t.string   "ou"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppier_files", force: true do |t|
    t.string   "filepath"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", force: true do |t|
    t.string   "OU"
    t.string   "SupplierNo"
    t.string   "SupplerName"
    t.string   "AB"
    t.string   "BC"
    t.string   "MA"
    t.string   "NB"
    t.string   "NF"
    t.string   "NS"
    t.string   "NU"
    t.string   "NT"
    t.string   "FC"
    t.string   "ONT"
    t.string   "PE"
    t.string   "QC"
    t.string   "SK"
    t.string   "YU"
    t.string   "IO"
    t.string   "IQ"
    t.string   "GSTHST"
    t.string   "Account"
    t.string   "SubAccount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filepath"
    t.string   "user"
    t.string   "size"
    t.string   "ftype"
    t.boolean  "valid"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "validators", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
