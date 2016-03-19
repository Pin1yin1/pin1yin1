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

ActiveRecord::Schema.define(version: 20160101202939) do

  create_table "definition_characters", force: :cascade do |t|
    t.integer "definition_id", limit: 4,                 null: false
    t.string  "character",     limit: 1,                 null: false
    t.boolean "active",                  default: false, null: false
  end

  add_index "definition_characters", ["character"], name: "index_definition_characters_on_character", using: :btree

  create_table "definitions", force: :cascade do |t|
    t.string  "characters_simplified",  limit: 255,                 null: false
    t.string  "characters_traditional", limit: 255,                 null: false
    t.string  "pinyin_ascii_tone",      limit: 255,                 null: false
    t.string  "pinyin_ascii",           limit: 255,                 null: false
    t.string  "english",                limit: 255,                 null: false
    t.boolean "active",                             default: false, null: false
    t.boolean "primary",                            default: false, null: false
  end

  add_index "definitions", ["characters_simplified"], name: "index_definitions_on_characters_simplified", using: :btree
  add_index "definitions", ["characters_traditional"], name: "index_definitions_on_characters_traditional", using: :btree
  add_index "definitions", ["pinyin_ascii"], name: "index_definitions_on_pinyin_ascii", using: :btree
  add_index "definitions", ["pinyin_ascii_tone"], name: "index_definitions_on_pinyin_ascii_tone", using: :btree

  create_table "syllables", force: :cascade do |t|
    t.integer "tone",              limit: 1,                   null: false
    t.string  "pinyin",            limit: 6,                   null: false
    t.string  "pinyin_ascii",      limit: 6,                   null: false
    t.string  "pinyin_ascii_tone", limit: 7,                   null: false
    t.string  "zhuyin",            limit: 3,                   null: false
    t.string  "zhuyin_tone",       limit: 255,                 null: false
    t.boolean "active",                        default: false, null: false
  end

  add_index "syllables", ["pinyin_ascii", "pinyin_ascii_tone"], name: "index_syllables_on_pinyin_ascii_and_pinyin_ascii_tone", using: :btree
  add_index "syllables", ["pinyin_ascii"], name: "index_syllables_on_pinyin_ascii", using: :btree
  add_index "syllables", ["pinyin_ascii_tone"], name: "index_syllables_on_pinyin_ascii_tone", using: :btree
  add_index "syllables", ["zhuyin"], name: "index_syllables_on_zhuyin", using: :btree

  create_table "zi", force: :cascade do |t|
    t.string  "character",             limit: 1,                 null: false
    t.integer "strokes",               limit: 1,                 null: false
    t.integer "radical",               limit: 1,                 null: false
    t.integer "strokes_after_radical", limit: 1,                 null: false
    t.integer "is_radical",            limit: 1,                 null: false
    t.integer "phonetic",              limit: 4,                 null: false
    t.integer "is_phonetic",           limit: 4,                 null: false
    t.boolean "active",                          default: false, null: false
    t.integer "simplified_zi_id",      limit: 4
    t.boolean "is_simplified",                   default: false, null: false
    t.boolean "is_traditional",                  default: false, null: false
    t.integer "is_radical_simplified", limit: 1,                 null: false
  end

  add_index "zi", ["active"], name: "index_zi_on_active", using: :btree
  add_index "zi", ["is_phonetic"], name: "index_zi_on_is_phonetic", using: :btree
  add_index "zi", ["is_radical"], name: "index_zi_on_is_radical", using: :btree
  add_index "zi", ["is_radical_simplified"], name: "index_zi_on_is_radical_simplified", using: :btree
  add_index "zi", ["is_simplified"], name: "index_zi_on_is_simplified", using: :btree
  add_index "zi", ["is_traditional"], name: "index_zi_on_is_traditional", using: :btree
  add_index "zi", ["phonetic"], name: "index_zi_on_phonetic", using: :btree
  add_index "zi", ["radical", "strokes_after_radical"], name: "index_zi_on_radical_and_strokes_after_radical", using: :btree
  add_index "zi", ["radical"], name: "index_zi_on_radical", using: :btree
  add_index "zi", ["simplified_zi_id"], name: "index_zi_on_simplified_zi_id", using: :btree
  add_index "zi", ["strokes"], name: "index_zi_on_strokes", using: :btree
  add_index "zi", ["strokes_after_radical"], name: "index_zi_on_strokes_after_radical", using: :btree

end
