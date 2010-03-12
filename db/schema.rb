# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091215035130) do

  create_table "battles", :force => true do |t|
    t.integer  "ship1_id"
    t.integer  "ship2_id"
    t.text     "recap"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.datetime "created"
    t.integer  "user_id"
    t.integer  "gold"
    t.float    "exp"
    t.integer  "lvl"
    t.integer  "exp_next"
    t.integer  "total_points"
    t.integer  "lucky"
    t.integer  "penny"
    t.integer  "goldrush"
    t.integer  "cannonmastery"
    t.integer  "trueshot"
    t.integer  "shootingblind"
    t.integer  "olsturdy"
    t.integer  "smoothsailing"
    t.integer  "cargoreduction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "information", :force => true do |t|
    t.datetime "created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "volume"
    t.float    "hitpoints_w"
    t.float    "speed_w"
    t.float    "attack_w"
    t.float    "accuracy_w"
    t.float    "evasion_w"
    t.integer  "price_w"
    t.string   "slot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_items", :force => true do |t|
    t.float    "buy_w"
    t.float    "sell_w"
    t.integer  "merchant_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchants", :force => true do |t|
    t.string   "name"
    t.integer  "port_id"
    t.integer  "rarity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_copies", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "message_id"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read"
  end

  create_table "messages", :force => true do |t|
    t.integer  "author_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_posts", :force => true do |t|
    t.string   "author"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", :force => true do |t|
    t.string   "typ"
    t.string   "opt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", :force => true do |t|
    t.integer  "start_id"
    t.integer  "end_id"
    t.integer  "distance"
    t.integer  "common_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :limit => 500, :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "ship_attributes", :force => true do |t|
    t.integer  "ship_id"
    t.integer  "cargo"
    t.integer  "weapon_slot"
    t.integer  "mast_slot"
    t.integer  "crew_slot"
    t.integer  "custom_slot"
    t.integer  "structure"
    t.integer  "rudder_slot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ship_items", :force => true do |t|
    t.integer  "item_id"
    t.integer  "ship_id"
    t.integer  "quantity"
    t.boolean  "equiped"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", :force => true do |t|
    t.string   "name"
    t.integer  "character_id"
    t.integer  "port_id"
    t.integer  "curr_hp"
    t.integer  "aggressive"
    t.string   "attack_mod_type"
    t.integer  "attack_mod_num"
    t.integer  "flee"
    t.string   "flee_mod_type"
    t.integer  "flee_mod_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_tasks", :force => true do |t|
    t.string   "name"
    t.string   "task"
    t.string   "param1"
    t.string   "param2"
    t.string   "param3"
    t.datetime "when"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "account"
    t.string   "email"
    t.string   "password"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authorization_token"
  end

end
