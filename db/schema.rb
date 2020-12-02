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

ActiveRecord::Schema.define(version: 2020_12_02_082531) do

  create_table "armours", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "name"
    t.integer "soak"
    t.integer "hardness"
    t.integer "mobility_penalty"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_armours_on_character_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "discord_user"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "spark"
    t.string "player_name"
    t.string "caste"
    t.string "concept"
    t.string "anima"
    t.string "supernal"
    t.string "lineage"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "stamina"
    t.integer "charisma"
    t.integer "manipulation"
    t.integer "appearance"
    t.integer "perception"
    t.integer "intelligence"
    t.integer "wits"
    t.integer "archery"
    t.boolean "favoured_archery"
    t.integer "athletics"
    t.boolean "favoured_athletics"
    t.integer "awareness"
    t.boolean "favoured_awareness"
    t.integer "brawl"
    t.boolean "favoured_brawl"
    t.integer "bureaucracy"
    t.boolean "favoured_bureaucracy"
    t.integer "craft"
    t.boolean "favoured_craft"
    t.integer "dodge"
    t.boolean "favoured_dodge"
    t.integer "integrity"
    t.boolean "favoured_integrity"
    t.integer "investigation"
    t.boolean "favoured_investigation"
    t.integer "larceny"
    t.boolean "favoured_larceny"
    t.integer "linguistics"
    t.boolean "favoured_linguistics"
    t.integer "lore"
    t.boolean "favoured_lore"
    t.integer "martial_arts"
    t.boolean "favoured_martial_arts"
    t.integer "medicine"
    t.boolean "favoured_medicine"
    t.integer "melee"
    t.boolean "favoured_melee"
    t.integer "occult"
    t.boolean "favoured_occult"
    t.integer "performance"
    t.boolean "favoured_performance"
    t.integer "presence"
    t.boolean "favoured_presence"
    t.integer "resistance"
    t.boolean "favoured_resistance"
    t.integer "ride"
    t.boolean "favoured_ride"
    t.integer "sail"
    t.boolean "favoured_sail"
    t.integer "socialise"
    t.boolean "favoured_socialise"
    t.integer "stealth"
    t.boolean "favoured_stealth"
    t.integer "survival"
    t.boolean "favoured_survival"
    t.integer "thrown"
    t.boolean "favoured_thrown"
    t.integer "war"
    t.boolean "favoured_war"
    t.integer "permanent_wp"
    t.integer "remaining_wp"
    t.integer "limit_break"
    t.integer "permanent_ess"
    t.integer "remain_personal_ess"
    t.integer "remain_periph_ess"
    t.integer "committed_ess"
    t.string "limit_trigger"
    t.integer "unspent_xp"
    t.integer "total_xp"
    t.integer "unspent_spark_xp"
    t.integer "total_spark_xp"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "charms", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "name"
    t.string "ability"
    t.integer "variety"
    t.string "duration"
    t.string "cost"
    t.string "keywords"
    t.text "effect"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_charms_on_character_id"
  end

  create_table "health_levels", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "penalty"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_health_levels_on_character_id"
  end

  create_table "intimacies", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "variety"
    t.string "name"
    t.integer "intensity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_intimacies_on_character_id"
  end

  create_table "merits", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "name"
    t.string "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_merits_on_character_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "ability"
    t.string "situation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_specialties_on_character_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.integer "discord_uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.integer "character_id", null: false
    t.string "name"
    t.integer "accuracy"
    t.integer "damage"
    t.integer "defence"
    t.integer "overwhelming"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "wielded"
    t.index ["character_id"], name: "index_weapons_on_character_id"
  end

  add_foreign_key "armours", "characters"
  add_foreign_key "characters", "users"
  add_foreign_key "charms", "characters"
  add_foreign_key "health_levels", "characters"
  add_foreign_key "intimacies", "characters"
  add_foreign_key "merits", "characters"
  add_foreign_key "specialties", "characters"
  add_foreign_key "weapons", "characters"
end
