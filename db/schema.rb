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

ActiveRecord::Schema.define(version: 20140423005201) do

  create_table "data_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_hs", force: true do |t|
    t.integer  "inv_id"
    t.string   "province"
    t.boolean  "valid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.string   "inv_n"
    t.string   "supplier"
    t.decimal  "inv_amt",    precision: 16, scale: 2
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
    t.string   "SupplierNo"
    t.string   "SupplerName"
    t.string   "Account"
    t.string   "SubAccount"
    t.string   "OU"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "GSTHST"
  end

  create_table "uploads", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filepath"
  end

  create_table "users", force: true do |t|
    t.string   "user_id"
    t.string   "password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
