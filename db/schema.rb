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

ActiveRecord::Schema.define(version: 20180602073211) do

  create_table "ipns", force: :cascade do |t|
    t.string "order_invoice"
    t.string "ipn_track_id"
    t.string "txn_id"
    t.string "payer_id"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ipn_track_id"], name: "index_ipns_on_ipn_track_id"
    t.index ["order_invoice"], name: "index_ipns_on_order_invoice"
    t.index ["payer_id"], name: "index_ipns_on_payer_id"
    t.index ["txn_id"], name: "index_ipns_on_txn_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "product_id"
    t.integer "order_id"
    t.integer "quantity"
    t.decimal "price"
    t.text "mode"
    t.text "platform"
    t.text "specials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.string "status"
    t.string "coupon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "details"
    t.string "invoice"
    t.string "account_name"
    t.string "account_password"
    t.string "discord"
    t.string "email"
    t.string "skype"
    t.string "preferred_communication"
    t.index ["invoice"], name: "index_orders_on_invoice"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "image_url"
    t.decimal "price"
    t.text "description"
    t.text "specials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_products_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "city"
    t.string "country"
    t.string "post_code"
    t.string "account_name"
    t.string "account_password"
    t.string "discord"
    t.string "contact_email"
    t.string "skype"
    t.string "preferred_communication"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "webhook_id"
    t.string "order_invoice"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_invoice"], name: "index_webhooks_on_order_invoice"
    t.index ["webhook_id"], name: "index_webhooks_on_webhook_id"
  end

end
