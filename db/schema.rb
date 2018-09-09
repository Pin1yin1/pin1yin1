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

ActiveRecord::Schema.define(version: 20180909054125) do

  create_table "definition_characters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "definition_id",                           null: false
    t.string  "character",     limit: 1,                 null: false
    t.boolean "active",                  default: false, null: false
    t.index ["character"], name: "index_definition_characters_on_character", using: :btree
  end

  create_table "definitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string  "characters_simplified",                  null: false
    t.string  "characters_traditional",                 null: false
    t.string  "pinyin_ascii_tone",                      null: false
    t.string  "pinyin_ascii",                           null: false
    t.string  "english",                                null: false
    t.boolean "active",                 default: false, null: false
    t.boolean "primary",                default: false, null: false
    t.index ["characters_simplified"], name: "index_definitions_on_characters_simplified", length: { characters_simplified: 191 }, using: :btree
    t.index ["characters_traditional"], name: "index_definitions_on_characters_traditional", length: { characters_traditional: 191 }, using: :btree
    t.index ["pinyin_ascii"], name: "index_definitions_on_pinyin_ascii", length: { pinyin_ascii: 191 }, using: :btree
    t.index ["pinyin_ascii_tone"], name: "index_definitions_on_pinyin_ascii_tone", length: { pinyin_ascii_tone: 191 }, using: :btree
  end

  create_table "syllables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "tone",              limit: 1,                 null: false
    t.string  "pinyin",            limit: 6,                 null: false
    t.string  "pinyin_ascii",      limit: 6,                 null: false
    t.string  "pinyin_ascii_tone", limit: 7,                 null: false
    t.string  "zhuyin",            limit: 3,                 null: false
    t.string  "zhuyin_tone",                                 null: false
    t.boolean "active",                      default: false, null: false
    t.index ["pinyin_ascii", "pinyin_ascii_tone"], name: "index_syllables_on_pinyin_ascii_and_pinyin_ascii_tone", using: :btree
    t.index ["pinyin_ascii"], name: "index_syllables_on_pinyin_ascii", using: :btree
    t.index ["pinyin_ascii_tone"], name: "index_syllables_on_pinyin_ascii_tone", using: :btree
    t.index ["zhuyin"], name: "index_syllables_on_zhuyin", using: :btree
  end

  create_table "zi", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string  "character",             limit: 1,                 null: false
    t.integer "strokes",               limit: 1,                 null: false
    t.integer "radical",               limit: 1,                 null: false, unsigned: true
    t.integer "strokes_after_radical", limit: 1,                 null: false
    t.integer "is_radical",            limit: 1,                 null: false, unsigned: true
    t.integer "phonetic",                                        null: false, unsigned: true
    t.integer "is_phonetic",                                     null: false, unsigned: true
    t.boolean "active",                          default: false, null: false
    t.integer "simplified_zi_id"
    t.boolean "is_simplified",                   default: false, null: false
    t.boolean "is_traditional",                  default: false, null: false
    t.integer "is_radical_simplified", limit: 1,                 null: false, unsigned: true
    t.index ["active"], name: "index_zi_on_active", using: :btree
    t.index ["is_phonetic"], name: "index_zi_on_is_phonetic", using: :btree
    t.index ["is_radical"], name: "index_zi_on_is_radical", using: :btree
    t.index ["is_radical_simplified"], name: "index_zi_on_is_radical_simplified", using: :btree
    t.index ["is_simplified"], name: "index_zi_on_is_simplified", using: :btree
    t.index ["is_traditional"], name: "index_zi_on_is_traditional", using: :btree
    t.index ["phonetic"], name: "index_zi_on_phonetic", using: :btree
    t.index ["radical", "strokes_after_radical"], name: "index_zi_on_radical_and_strokes_after_radical", using: :btree
    t.index ["radical"], name: "index_zi_on_radical", using: :btree
    t.index ["simplified_zi_id"], name: "index_zi_on_simplified_zi_id", using: :btree
    t.index ["strokes"], name: "index_zi_on_strokes", using: :btree
    t.index ["strokes_after_radical"], name: "index_zi_on_strokes_after_radical", using: :btree
  end

end
