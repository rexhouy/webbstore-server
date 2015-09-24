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

ActiveRecord::Schema.define(version: 20150924081602) do

  create_table "addresses", force: :cascade do |t|
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "street",     limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "tel",        limit: 255
    t.string   "name",       limit: 255
    t.integer  "status",     limit: 4
  end

  add_index "addresses", ["user_id"], name: "fk_rails_12809c9026", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "content",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "group_id",   limit: 4
  end

  create_table "captchas", force: :cascade do |t|
    t.string   "tel",              limit: 11, null: false
    t.string   "register_token",   limit: 6,  null: false
    t.datetime "register_sent_at",            null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "captchas", ["tel"], name: "index_captchas_on_tel", unique: true, using: :btree

  create_table "card_histories", force: :cascade do |t|
    t.date     "delivery_date"
    t.integer  "card_id",       limit: 4
    t.integer  "remain",        limit: 4
    t.string   "memo",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.integer  "specification_id", limit: 4
    t.integer  "order_id",         limit: 4
    t.integer  "count",            limit: 4
    t.integer  "remain",           limit: 4
    t.date     "next"
    t.integer  "status",           limit: 4
    t.string   "contact_name",     limit: 255
    t.string   "contact_tel",      limit: 255
    t.string   "contact_address",  limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "from",             limit: 4
    t.string   "name",             limit: 255
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.integer  "category_id", limit: 4
    t.integer  "group_id",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "priority",    limit: 4
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "group_id",   limit: 4
    t.string   "image",      limit: 255
    t.string   "url",        limit: 255
    t.integer  "priority",   limit: 4
    t.string   "color",      limit: 255
  end

  add_index "channels", ["group_id"], name: "fk_rails_8011c05949", using: :btree

  create_table "complain_histories", force: :cascade do |t|
    t.datetime "time"
    t.integer  "complain_id", limit: 4
    t.integer  "status",      limit: 4
    t.string   "memo",        limit: 255
    t.integer  "user_id",     limit: 4
  end

  create_table "complains", force: :cascade do |t|
    t.integer  "order_id",        limit: 4
    t.text     "content",         limit: 65535
    t.string   "contact_name",    limit: 255
    t.string   "contact_tel",     limit: 11
    t.string   "contact_address", limit: 255
    t.string   "type",            limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "group_id",        limit: 4
    t.integer  "status",          limit: 4
    t.integer  "user_id",         limit: 4
    t.integer  "staff_id",        limit: 4
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     limit: 4
    t.integer  "parent_id",  limit: 4
  end

  create_table "order_histories", force: :cascade do |t|
    t.integer  "order_id",    limit: 4
    t.integer  "status",      limit: 4
    t.datetime "time"
    t.integer  "operator_id", limit: 4
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status",          limit: 4
    t.decimal  "subtotal",                      precision: 10, scale: 2
    t.integer  "seller_id",       limit: 4
    t.integer  "customer_id",     limit: 4
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "order_id",        limit: 255
    t.integer  "payment_type",    limit: 4
    t.string   "name",            limit: 255
    t.string   "contact_name",    limit: 255
    t.string   "contact_tel",     limit: 11
    t.string   "contact_address", limit: 255
    t.text     "memo",            limit: 65535
    t.integer  "delivery_type",   limit: 4
  end

  add_index "orders", ["customer_id"], name: "fk_rails_c2426400ce", using: :btree
  add_index "orders", ["seller_id"], name: "fk_rails_4498acc18a", using: :btree

  create_table "orders_products", force: :cascade do |t|
    t.integer  "count",            limit: 4
    t.decimal  "price",                      precision: 10, scale: 2
    t.integer  "order_id",         limit: 4
    t.integer  "product_id",       limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "specification_id", limit: 4
  end

  add_index "orders_products", ["order_id"], name: "fk_rails_889bfce267", using: :btree
  add_index "orders_products", ["product_id"], name: "fk_rails_331586c13a", using: :btree
  add_index "orders_products", ["specification_id"], name: "index_orders_products_on_specification_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer "payment_type", limit: 4
    t.text    "trade_info",   limit: 65535
    t.integer "order_id",     limit: 4
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.text     "article",     limit: 65535
    t.string   "cover_image", limit: 255
    t.integer  "owner_id",    limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "recommend",   limit: 1
    t.boolean  "on_sale",     limit: 1
    t.decimal  "price",                     precision: 8, scale: 2
    t.integer  "storage",     limit: 4
    t.integer  "sales",       limit: 4
    t.integer  "status",      limit: 4
    t.integer  "priority",    limit: 4
    t.integer  "supplier_id", limit: 4
    t.integer  "category_id", limit: 4
    t.string   "barcode",     limit: 255
  end

  add_index "products", ["name", "description", "article"], name: "fulltext_index", type: :fulltext
  add_index "products", ["owner_id"], name: "fk_rails_718105988b", using: :btree

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "specifications", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.integer  "product_id", limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.decimal  "price",                  precision: 8, scale: 2
    t.integer  "storage",    limit: 4
    t.integer  "sales",      limit: 4
    t.integer  "status",     limit: 4
    t.integer  "count",      limit: 4
  end

  add_index "specifications", ["product_id"], name: "fk_rails_9b321d46dc", using: :btree

  create_table "staffs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "workday",    limit: 4
    t.string   "tel",        limit: 11
    t.string   "scope",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "photo",      limit: 255
    t.integer  "group_id",   limit: 4
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "group_id",   limit: 4
  end

  create_table "trades", force: :cascade do |t|
    t.datetime "time"
    t.string   "type",             limit: 255
    t.string   "payer",            limit: 255
    t.decimal  "receipt",                      precision: 8, scale: 2
    t.decimal  "disbursement",                 precision: 8, scale: 2
    t.decimal  "balance",                      precision: 8, scale: 2
    t.string   "supplier",         limit: 255
    t.string   "order_no",         limit: 255
    t.string   "trade_no",         limit: 255
    t.integer  "group_id",         limit: 4
    t.decimal  "supplier_balance",             precision: 8, scale: 2
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: ""
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
    t.integer  "role",                   limit: 4
    t.integer  "group_id",               limit: 4
    t.integer  "status",                 limit: 4
    t.string   "tel",                    limit: 11,               null: false
    t.string   "wechat_openid",          limit: 255
    t.boolean  "order_notification",     limit: 1
    t.integer  "failed_attempts",        limit: 4,   default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.integer  "introducer",             limit: 4
    t.string   "introducer_token",       limit: 255
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree
  add_index "users", ["tel"], name: "index_users_on_tel", unique: true, using: :btree

  add_foreign_key "channels", "groups"
  add_foreign_key "orders", "groups", column: "seller_id"
  add_foreign_key "orders", "users", column: "customer_id"
  add_foreign_key "orders_products", "orders"
  add_foreign_key "orders_products", "products"
  add_foreign_key "orders_products", "specifications", on_delete: :cascade
  add_foreign_key "products", "groups", column: "owner_id"
  add_foreign_key "specifications", "products", on_delete: :cascade
  add_foreign_key "users", "groups"
end
