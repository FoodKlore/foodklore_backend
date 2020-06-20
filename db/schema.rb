# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_17_224546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.text "business_name"
    t.text "phone_number"
    t.text "direction"
    t.text "business_description"
    t.text "img"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "guests", force: :cascade do |t|
    t.string "email"
    t.boolean "authenticated"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "security_code_digest"
  end

  create_table "ingredients", force: :cascade do |t|
    t.text "name"
    t.bigint "menu_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_id"], name: "index_ingredients_on_menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "img"
    t.float "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "business_id"
    t.index ["name"], name: "index_menus_on_name"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.float "total"
    t.bigint "order_status_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "shoppingcart_id"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["shoppingcart_id"], name: "index_orders_on_shoppingcart_id"
  end

  create_table "shoppingcart_items", force: :cascade do |t|
    t.bigint "shoppingcart_id", null: false
    t.bigint "menu_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_id"], name: "index_shoppingcart_items_on_menu_id"
    t.index ["shoppingcart_id"], name: "index_shoppingcart_items_on_shoppingcart_id"
  end

  create_table "shoppingcarts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active"
    t.index ["created_at"], name: "index_subscribers_on_created_at"
    t.index ["email"], name: "index_subscribers_on_email", unique: true
    t.index ["updated_at"], name: "index_subscribers_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "nickname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "email_confirmed", default: false
  end

  add_foreign_key "ingredients", "menus"
  add_foreign_key "menus", "businesses"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "orders", "shoppingcarts"
  add_foreign_key "shoppingcart_items", "menus"
  add_foreign_key "shoppingcart_items", "shoppingcarts"
end
