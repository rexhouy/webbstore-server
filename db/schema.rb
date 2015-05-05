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

ActiveRecord::Schema.define(version: 20150505030921) do

  create_table "addresses", force: :cascade do |t|
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "street",     limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "addresses", ["user_id"], name: "fk_rails_12809c9026", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.integer  "product_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "images", ["product_id"], name: "fk_rails_ba13ebbede", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "status",      limit: 4
    t.decimal  "subtotal",                precision: 10
    t.integer  "seller_id",   limit: 4
    t.integer  "customer_id", limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "order_id",    limit: 255
  end

  add_index "orders", ["customer_id"], name: "fk_rails_c2426400ce", using: :btree
  add_index "orders", ["seller_id"], name: "fk_rails_8784ace20d", using: :btree

  create_table "orders_products", force: :cascade do |t|
    t.integer  "count",      limit: 4
    t.decimal  "price",                precision: 10
    t.integer  "order_id",   limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "orders_products", ["order_id"], name: "fk_rails_889bfce267", using: :btree
  add_index "orders_products", ["product_id"], name: "fk_rails_331586c13a", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.text     "article",     limit: 65535
    t.decimal  "price",                     precision: 10
    t.integer  "status",      limit: 4
    t.string   "cover_image", limit: 255
    t.integer  "owner_id",    limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "storage",     limit: 4
    t.integer  "sales",       limit: 4
    t.boolean  "recommend",   limit: 1
  end

  add_index "products", ["owner_id"], name: "fk_rails_8fad8a61b3", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "addresses", "users"
  add_foreign_key "images", "products"
  add_foreign_key "orders", "users", column: "customer_id"
  add_foreign_key "orders", "users", column: "customer_id"
  add_foreign_key "orders", "users", column: "seller_id"
  add_foreign_key "orders", "users", column: "seller_id"
  add_foreign_key "orders_products", "orders"
  add_foreign_key "orders_products", "orders"
  add_foreign_key "orders_products", "products"
  add_foreign_key "orders_products", "products"
  add_foreign_key "products", "users", column: "owner_id"
  add_foreign_key "products", "users", column: "owner_id"
end
