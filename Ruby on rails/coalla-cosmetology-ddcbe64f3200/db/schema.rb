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

ActiveRecord::Schema.define(version: 20210113183219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_images", force: :cascade do |t|
    t.text     "type"
    t.text     "name"
    t.text     "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "about_images", ["shop_id"], name: "index_about_images_on_shop_id", using: :btree

  create_table "advantages", force: :cascade do |t|
    t.text     "title"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "amo_module_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "amo_module_id"
    t.integer  "position",      default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "amo_module_courses", ["amo_module_id"], name: "index_amo_module_courses_on_amo_module_id", using: :btree
  add_index "amo_module_courses", ["course_id"], name: "index_amo_module_courses_on_course_id", using: :btree

  create_table "amo_modules", force: :cascade do |t|
    t.text     "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "amo_requests", force: :cascade do |t|
    t.string   "method",     null: false
    t.text     "url",        null: false
    t.text     "params",     null: false
    t.float    "timeout",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "amo_requests", ["created_at"], name: "index_amo_requests_on_created_at", using: :btree

  create_table "amocrm_imports", force: :cascade do |t|
    t.boolean  "completed",     default: false, null: false
    t.datetime "completed_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "job_id"
    t.text     "errors_string"
  end

  create_table "amocrm_pipelines", force: :cascade do |t|
    t.text     "title",      null: false
    t.text     "amocrm_id",  null: false
    t.integer  "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "amocrm_pipelines", ["shop_id"], name: "index_amocrm_pipelines_on_shop_id", using: :btree

  create_table "amocrm_statuses", force: :cascade do |t|
    t.text     "title",              null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "amocrm_id",          null: false
    t.integer  "amocrm_pipeline_id"
    t.string   "status_action"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "user_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token", "user_id"], name: "index_api_keys_on_access_token_and_user_id", unique: true, using: :btree
  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.text     "type"
    t.text     "title"
    t.text     "slug"
    t.text     "announce"
    t.text     "main_image"
    t.text     "main_image_title"
    t.text     "preview_image"
    t.text     "preview_announce"
    t.text     "content"
    t.boolean  "published",        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "tag_title"
    t.text     "tag_description"
    t.integer  "shop_id"
    t.text     "button_text"
    t.text     "button_link"
    t.boolean  "for_main",         default: false, null: false
    t.string   "button_type"
  end

  add_index "articles", ["shop_id"], name: "index_articles_on_shop_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.text     "item"
    t.integer  "letter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attachments", ["letter_id"], name: "index_attachments_on_letter_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.text     "uid",                 null: false
    t.text     "provider",            null: false
    t.text     "access_token",        null: false
    t.text     "access_token_secret"
    t.text     "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["uid"], name: "index_authentications_on_uid", using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "automatic_discounts", force: :cascade do |t|
    t.text     "name"
    t.integer  "discount_id"
    t.boolean  "enabled",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "automatic_discounts", ["discount_id"], name: "index_automatic_discounts_on_discount_id", using: :btree

  create_table "banners", force: :cascade do |t|
    t.text     "type_banner"
    t.text     "description",                  null: false
    t.text     "image",                        null: false
    t.text     "btn_title"
    t.text     "link_call"
    t.boolean  "active",       default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "mobile_text"
    t.text     "mobile_image"
    t.integer  "shop_id"
  end

  add_index "banners", ["shop_id"], name: "index_banners_on_shop_id", using: :btree

  create_table "blocks", force: :cascade do |t|
    t.text     "name",                       null: false
    t.boolean  "active",     default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "delta",      default: true,  null: false
    t.boolean  "cloned",     default: false, null: false
    t.integer  "shop_id"
  end

  add_index "blocks", ["active"], name: "index_blocks_on_active", using: :btree
  add_index "blocks", ["name"], name: "index_blocks_on_name", using: :btree
  add_index "blocks", ["shop_id"], name: "index_blocks_on_shop_id", using: :btree

  create_table "blog_categories", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "blog_categories", ["article_id"], name: "index_blog_categories_on_article_id", using: :btree
  add_index "blog_categories", ["category_id"], name: "index_blog_categories_on_category_id", using: :btree
  add_index "blog_categories", ["shop_id"], name: "index_blog_categories_on_shop_id", using: :btree

  create_table "blog_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   default: 0, null: false
  end

  add_index "blog_courses", ["article_id"], name: "index_blog_courses_on_article_id", using: :btree
  add_index "blog_courses", ["course_id"], name: "index_blog_courses_on_course_id", using: :btree

  create_table "blog_square_banners", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "square_banner_id"
    t.integer  "position",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_square_banners", ["article_id"], name: "index_blog_square_banners_on_article_id", using: :btree
  add_index "blog_square_banners", ["square_banner_id"], name: "index_blog_square_banners_on_square_banner_id", using: :btree

  create_table "blog_subscribers", force: :cascade do |t|
    t.text     "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blog_subscribers", ["email"], name: "index_blog_subscribers_on_email", unique: true, using: :btree
  add_index "blog_subscribers", ["user_id"], name: "index_blog_subscribers_on_user_id", using: :btree

  create_table "book_categories", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "book_categories", ["name"], name: "index_book_categories_on_name", unique: true, using: :btree

  create_table "books", force: :cascade do |t|
    t.text     "author"
    t.text     "name"
    t.integer  "book_category_id"
    t.text     "description"
    t.integer  "code"
    t.text     "cover"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "views_count",      default: 0
    t.boolean  "delta",            default: true, null: false
    t.text     "secret_password"
    t.text     "pdf"
    t.text     "pdf_status"
    t.text     "type"
  end

  add_index "books", ["book_category_id"], name: "index_books_on_book_category_id", using: :btree

  create_table "call_results", force: :cascade do |t|
    t.string   "status"
    t.integer  "group_subscription_id"
    t.integer  "duration"
    t.string   "code"
    t.string   "user_input"
    t.boolean  "processed",             default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "call_results", ["group_subscription_id"], name: "index_call_results_on_group_subscription_id", using: :btree

  create_table "campaign_indices", force: :cascade do |t|
    t.integer  "campaign_id"
    t.string   "name"
    t.string   "service"
    t.float    "value",       default: 0.0, null: false
    t.date     "created_on"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "campaign_indices", ["campaign_id"], name: "index_campaign_indices_on_campaign_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.text     "co_magick_id",               null: false
    t.text     "name"
    t.text     "phone_type"
    t.text     "phone"
    t.text     "utm_sources",   default: [],              array: true
    t.text     "utm_mediums",   default: [],              array: true
    t.text     "utm_campaigns", default: [],              array: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "seopult_id"
  end

  create_table "cash_receipts", force: :cascade do |t|
    t.integer  "code"
    t.integer  "uuid"
    t.text     "response"
    t.integer  "item_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "request"
    t.string   "item_type",  default: "Order"
  end

  add_index "cash_receipts", ["item_id"], name: "index_cash_receipts_on_item_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "categories", ["shop_id"], name: "index_categories_on_shop_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "classrooms", force: :cascade do |t|
    t.text     "title",                   null: false
    t.integer  "capacity",    default: 0, null: false
    t.integer  "external_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "column_variants", force: :cascade do |t|
    t.text     "title"
    t.integer  "column_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image"
  end

  add_index "column_variants", ["column_id"], name: "index_column_variants_on_column_id", using: :btree

  create_table "columns", force: :cascade do |t|
    t.text     "title"
    t.integer  "task_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "columns", ["task_id"], name: "index_columns_on_task_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.integer  "creator_id",       null: false
    t.string   "creator_type",     null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["creator_type", "creator_id"], name: "index_comments_on_creator_type_and_creator_id", using: :btree

  create_table "consultations", force: :cascade do |t|
    t.text     "name"
    t.string   "email"
    t.string   "phone"
    t.text     "comment"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "consultations", ["course_id"], name: "index_consultations_on_course_id", using: :btree

  create_table "cosmetology_procedures", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "shop_id"
  end

  add_index "cosmetology_procedures", ["shop_id"], name: "index_cosmetology_procedures_on_shop_id", using: :btree

  create_table "course_advantages", force: :cascade do |t|
    t.integer  "advantage_id"
    t.integer  "course_id"
    t.integer  "position",     default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "course_advantages", ["advantage_id"], name: "index_course_advantages_on_advantage_id", using: :btree
  add_index "course_advantages", ["course_id"], name: "index_course_advantages_on_course_id", using: :btree
  add_index "course_advantages", ["position"], name: "index_course_advantages_on_position", using: :btree

  create_table "course_automatic_discounts", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "automatic_discount_id"
    t.integer  "position",              default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_automatic_discounts", ["automatic_discount_id"], name: "index_course_automatic_discounts_on_automatic_discount_id", using: :btree
  add_index "course_automatic_discounts", ["course_id"], name: "index_course_automatic_discounts_on_course_id", using: :btree

  create_table "course_blocks", force: :cascade do |t|
    t.integer  "block_id"
    t.integer  "course_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "course_blocks", ["block_id"], name: "index_course_blocks_on_block_id", using: :btree
  add_index "course_blocks", ["course_id"], name: "index_course_blocks_on_course_id", using: :btree

  create_table "course_curriculum_blocks", force: :cascade do |t|
    t.integer  "curriculum_block_id"
    t.integer  "course_id"
    t.integer  "position",            default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "course_curriculum_blocks", ["course_id"], name: "index_course_curriculum_blocks_on_course_id", using: :btree
  add_index "course_curriculum_blocks", ["curriculum_block_id"], name: "index_course_curriculum_blocks_on_curriculum_block_id", using: :btree
  add_index "course_curriculum_blocks", ["position"], name: "index_course_curriculum_blocks_on_position", using: :btree

  create_table "course_documents", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "education_level_id"
    t.integer  "education_document_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "academic_hours"
    t.text     "program_name"
    t.text     "diploma_title"
  end

  add_index "course_documents", ["course_id"], name: "index_course_documents_on_course_id", using: :btree
  add_index "course_documents", ["education_document_id"], name: "index_course_documents_on_education_document_id", using: :btree
  add_index "course_documents", ["education_level_id"], name: "index_course_documents_on_education_level_id", using: :btree

  create_table "course_education_documents", force: :cascade do |t|
    t.integer  "education_document_id"
    t.integer  "course_id"
    t.integer  "position",              default: 0, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "course_education_documents", ["course_id"], name: "index_course_education_documents_on_course_id", using: :btree
  add_index "course_education_documents", ["education_document_id"], name: "index_course_education_documents_on_education_document_id", using: :btree
  add_index "course_education_documents", ["position"], name: "index_course_education_documents_on_position", using: :btree

  create_table "course_instructors", force: :cascade do |t|
    t.integer  "instructor_id"
    t.integer  "course_id"
    t.integer  "position",      default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "course_instructors", ["course_id"], name: "index_course_instructors_on_course_id", using: :btree
  add_index "course_instructors", ["instructor_id"], name: "index_course_instructors_on_instructor_id", using: :btree
  add_index "course_instructors", ["position"], name: "index_course_instructors_on_position", using: :btree

  create_table "course_links", force: :cascade do |t|
    t.text     "link"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "course_links", ["course_id"], name: "index_course_links_on_course_id", using: :btree

  create_table "course_promo_codes", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "promo_code_id"
    t.integer  "position",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_promo_codes", ["course_id"], name: "index_course_promo_codes_on_course_id", using: :btree
  add_index "course_promo_codes", ["promo_code_id"], name: "index_course_promo_codes_on_promo_code_id", using: :btree

  create_table "course_recalls", force: :cascade do |t|
    t.integer  "recall_id"
    t.integer  "course_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "course_recalls", ["course_id"], name: "index_course_recalls_on_course_id", using: :btree
  add_index "course_recalls", ["position"], name: "index_course_recalls_on_position", using: :btree
  add_index "course_recalls", ["recall_id"], name: "index_course_recalls_on_recall_id", using: :btree

  create_table "course_seos", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "place"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "course_seos", ["course_id"], name: "index_course_seos_on_course_id", using: :btree
  add_index "course_seos", ["place"], name: "index_course_seos_on_place", using: :btree

  create_table "course_skills", force: :cascade do |t|
    t.integer  "skill_id"
    t.integer  "course_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "course_skills", ["course_id"], name: "index_course_skills_on_course_id", using: :btree
  add_index "course_skills", ["position"], name: "index_course_skills_on_position", using: :btree
  add_index "course_skills", ["skill_id"], name: "index_course_skills_on_skill_id", using: :btree

  create_table "course_specialities", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "speciality_id"
    t.integer  "position",      default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "course_specialities", ["course_id"], name: "index_course_specialities_on_course_id", using: :btree
  add_index "course_specialities", ["position"], name: "index_course_specialities_on_position", using: :btree
  add_index "course_specialities", ["speciality_id"], name: "index_course_specialities_on_speciality_id", using: :btree

  create_table "course_works", force: :cascade do |t|
    t.integer  "hours"
    t.boolean  "main",       default: false, null: false
    t.integer  "course_id"
    t.integer  "work_id"
    t.integer  "lecture_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "position",   default: 0,     null: false
    t.boolean  "practice",   default: false, null: false
  end

  add_index "course_works", ["course_id"], name: "index_course_works_on_course_id", using: :btree
  add_index "course_works", ["lecture_id"], name: "index_course_works_on_lecture_id", using: :btree
  add_index "course_works", ["work_id"], name: "index_course_works_on_work_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.text     "name",                                                    null: false
    t.boolean  "active",                   default: false,                null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.text     "syllabus"
    t.boolean  "delta",                    default: true,                 null: false
    t.text     "timetable"
    t.integer  "price"
    t.text     "external_url"
    t.text     "short_name"
    t.integer  "hours",                    default: 0,                    null: false
    t.integer  "faculty_id"
    t.integer  "remote_price",             default: 0,                    null: false
    t.text     "appointment",                                             null: false
    t.integer  "cost",                     default: 0
    t.string   "slug"
    t.string   "title"
    t.text     "image"
    t.text     "announcement"
    t.float    "practice_hours",           default: 0.0,                  null: false
    t.float    "price_per_month",          default: 0.0,                  null: false
    t.float    "total_price",              default: 0.0,                  null: false
    t.string   "limitation"
    t.text     "video"
    t.boolean  "early_booking",            default: false,                null: false
    t.float    "economy",                  default: 0.0,                  null: false
    t.string   "job"
    t.float    "profit",                   default: 0.0,                  null: false
    t.text     "small_image"
    t.boolean  "special_offer",            default: false,                null: false
    t.integer  "nearest_group_id"
    t.date     "nearest_education_day"
    t.integer  "education_period",         default: 6,                    null: false
    t.text     "subject"
    t.boolean  "medical_education",        default: false,                null: false
    t.boolean  "work_in_cosmetology",      default: false,                null: false
    t.text     "tag_title"
    t.text     "tag_description"
    t.text     "badge"
    t.text     "diplom_title"
    t.text     "status_notification_name", default: "other_notification", null: false
    t.boolean  "place_over_notification",  default: false,                null: false
    t.boolean  "with_amo_module",          default: false,                null: false
    t.integer  "shop_id"
    t.boolean  "default_course",           default: false,                null: false
    t.text     "notification_audio"
    t.text     "ivr_audio"
    t.float    "economy_for_several"
    t.text     "economy_description"
    t.integer  "course_counts",            default: 0,                    null: false
    t.integer  "additional_amo_module_id"
    t.boolean  "student_docs_required",    default: true,                 null: false
  end

  add_index "courses", ["active"], name: "index_courses_on_active", using: :btree
  add_index "courses", ["additional_amo_module_id"], name: "index_courses_on_additional_amo_module_id", using: :btree
  add_index "courses", ["faculty_id"], name: "index_courses_on_faculty_id", using: :btree
  add_index "courses", ["name"], name: "index_courses_on_name", using: :btree
  add_index "courses", ["nearest_group_id"], name: "index_courses_on_nearest_group_id", using: :btree
  add_index "courses", ["shop_id"], name: "index_courses_on_shop_id", using: :btree

  create_table "curriculum_blocks", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "shop_id"
  end

  add_index "curriculum_blocks", ["shop_id"], name: "index_curriculum_blocks_on_shop_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "deleted_notices", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "notice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "deleted_notices", ["notice_id"], name: "index_deleted_notices_on_notice_id", using: :btree
  add_index "deleted_notices", ["student_id", "notice_id"], name: "index_deleted_notices_on_student_id_and_notice_id", unique: true, using: :btree
  add_index "deleted_notices", ["student_id"], name: "index_deleted_notices_on_student_id", using: :btree

  create_table "discounts", force: :cascade do |t|
    t.text     "title"
    t.text     "type"
    t.float    "value",      default: 0.0,   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "archival",   default: false, null: false
  end

  create_table "document_copies", force: :cascade do |t|
    t.text     "file"
    t.integer  "item_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "item_type",                      null: false
    t.boolean  "loaded_by_user", default: false
  end

  add_index "document_copies", ["item_id"], name: "index_document_copies_on_item_id", using: :btree

  create_table "document_sections", force: :cascade do |t|
    t.text     "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.text     "file"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "document_section_id"
  end

  add_index "documents", ["document_section_id"], name: "index_documents_on_document_section_id", using: :btree
  add_index "documents", ["file"], name: "index_documents_on_file", using: :btree

  create_table "downloads", force: :cascade do |t|
    t.text     "file"
    t.integer  "lecture_id"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "downloads", ["lecture_id", "position"], name: "index_downloads_on_lecture_id_and_position", using: :btree
  add_index "downloads", ["lecture_id"], name: "index_downloads_on_lecture_id", using: :btree

  create_table "education_document_pictures", force: :cascade do |t|
    t.integer  "education_document_id"
    t.text     "image"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "education_document_pictures", ["education_document_id"], name: "index_education_document_pictures_on_education_document_id", using: :btree

  create_table "education_documents", force: :cascade do |t|
    t.text     "title",       null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "code",        null: false
    t.string   "builder"
  end

  create_table "education_forms", force: :cascade do |t|
    t.text     "short_title",                 null: false
    t.text     "title",                       null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "online",      default: false, null: false
  end

  create_table "education_levels", force: :cascade do |t|
    t.text     "title",                   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "education_document_name"
  end

  create_table "en_pages", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exercise_results", force: :cascade do |t|
    t.text     "text"
    t.text     "parent_text"
    t.integer  "mark"
    t.integer  "exercise_id"
    t.integer  "student_work_result_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "exercise_results", ["exercise_id"], name: "index_exercise_results_on_exercise_id", using: :btree
  add_index "exercise_results", ["student_work_result_id"], name: "index_exercise_results_on_student_work_result_id", using: :btree

  create_table "exercises", force: :cascade do |t|
    t.text     "text"
    t.integer  "max_mark"
    t.integer  "index"
    t.integer  "work_id"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "exercises", ["parent_id"], name: "index_exercises_on_parent_id", using: :btree
  add_index "exercises", ["work_id"], name: "index_exercises_on_work_id", using: :btree

  create_table "expelled_students", force: :cascade do |t|
    t.integer  "hours",        default: 0, null: false
    t.integer  "expulsion_id"
    t.integer  "student_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "expelled_students", ["expulsion_id"], name: "index_expelled_students_on_expulsion_id", using: :btree
  add_index "expelled_students", ["student_id"], name: "index_expelled_students_on_student_id", using: :btree

  create_table "expulsions", force: :cascade do |t|
    t.integer  "group_id"
    t.boolean  "personal",       default: true, null: false
    t.boolean  "non_attendance", default: true, null: false
    t.date     "expelled_on"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "expulsions", ["group_id"], name: "index_expulsions_on_group_id", using: :btree

  create_table "faculties", force: :cascade do |t|
    t.text     "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "shop_id"
  end

  add_index "faculties", ["shop_id"], name: "index_faculties_on_shop_id", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "shop_id"
  end

  add_index "faqs", ["shop_id"], name: "index_faqs_on_shop_id", using: :btree

  create_table "feedback_questions", force: :cascade do |t|
    t.text     "type",             null: false
    t.integer  "student_id"
    t.integer  "instructor_id"
    t.integer  "index_id"
    t.text     "text"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "file"
    t.text     "student_name"
    t.text     "groups"
    t.text     "phone"
    t.text     "work_title"
    t.text     "absent_dates"
    t.text     "new_dates"
    t.text     "working_off_type"
    t.integer  "lecture_id"
  end

  add_index "feedback_questions", ["lecture_id"], name: "index_feedback_questions_on_lecture_id", using: :btree
  add_index "feedback_questions", ["student_id"], name: "index_feedback_questions_on_student_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finished_materials", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "material_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "finished_materials", ["material_id"], name: "index_finished_materials_on_material_id", using: :btree
  add_index "finished_materials", ["student_id", "material_id"], name: "index_finished_materials_on_student_id_and_material_id", unique: true, using: :btree
  add_index "finished_materials", ["student_id"], name: "index_finished_materials_on_student_id", using: :btree

  create_table "generated_documents", force: :cascade do |t|
    t.text     "path"
    t.text     "type"
    t.text     "file_name"
    t.float    "file_size"
    t.integer  "idx"
    t.text     "number"
    t.integer  "year"
    t.date     "created_on"
    t.integer  "item_id"
    t.string   "item_type"
    t.text     "user_file"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "with_print", default: false, null: false
  end

  add_index "generated_documents", ["idx"], name: "index_generated_documents_on_idx", using: :btree
  add_index "generated_documents", ["item_type", "item_id"], name: "index_generated_documents_on_item_type_and_item_id", using: :btree

  create_table "graduate_faculties", force: :cascade do |t|
    t.integer  "graduate_id"
    t.integer  "faculty_id"
    t.integer  "position",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graduate_faculties", ["faculty_id"], name: "index_graduate_faculties_on_faculty_id", using: :btree
  add_index "graduate_faculties", ["graduate_id"], name: "index_graduate_faculties_on_graduate_id", using: :btree

  create_table "graduates", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.text     "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "graduates", ["shop_id"], name: "index_graduates_on_shop_id", using: :btree

  create_table "group_prices", force: :cascade do |t|
    t.integer  "amount",                  default: 0,     null: false
    t.text     "payments_text",                           null: false
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "education_form_id"
    t.boolean  "early_booking",           default: false
    t.boolean  "bank_installment",        default: false
    t.integer  "bank_installment_months", default: 0
  end

  add_index "group_prices", ["education_form_id"], name: "index_group_prices_on_education_form_id", using: :btree
  add_index "group_prices", ["group_id"], name: "index_group_prices_on_group_id", using: :btree

  create_table "group_subscriptions", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "group_id"
    t.date     "begin_on"
    t.date     "end_on"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "deleted_at"
    t.integer  "education_form_id"
    t.integer  "discount_id"
    t.float    "price",                         default: 0.0,   null: false
    t.text     "payer"
    t.text     "amocrm_id"
    t.integer  "group_price_id"
    t.integer  "amocrm_status_id"
    t.boolean  "imported_from_amo",             default: false, null: false
    t.text     "practice"
    t.integer  "practice_basis_id"
    t.text     "payer_type"
    t.datetime "appendix_signed_on"
    t.datetime "appendix_expired_on"
    t.datetime "practice_agreement_signed_on"
    t.datetime "payer_agreement_signed_on"
    t.text     "itec"
    t.boolean  "expelled",                      default: false, null: false
    t.boolean  "academic_vacation",             default: false, null: false
    t.date     "vacation_begin_on"
    t.date     "vacation_end_on"
    t.datetime "sale_success_on"
    t.boolean  "created_by_user",               default: false
    t.datetime "pending_payment_at"
    t.text     "responsible_name"
    t.text     "amocrm_tags",                                                array: true
    t.integer  "amo_module_id"
    t.integer  "rating_place",                  default: 0
    t.integer  "rating_score",                  default: 0
    t.integer  "shop_id"
    t.boolean  "one_time_payment",              default: false, null: false
    t.boolean  "created_from_module",           default: false, null: false
    t.integer  "module_group_id"
    t.boolean  "practice_entrance_agree",       default: false, null: false
    t.datetime "practice_entrance_agree_at"
    t.boolean  "practice_entrance_disagree",    default: false, null: false
    t.datetime "practice_entrance_disagree_at"
    t.datetime "practice_date"
    t.datetime "practice_date_at"
    t.datetime "amo_module_at"
    t.integer  "promotion_id"
    t.text     "promotion_source"
    t.integer  "update_job_id"
    t.boolean  "double_created",                default: false, null: false
  end

  add_index "group_subscriptions", ["amo_module_id"], name: "index_group_subscriptions_on_amo_module_id", using: :btree
  add_index "group_subscriptions", ["amocrm_status_id"], name: "index_group_subscriptions_on_amocrm_status_id", using: :btree
  add_index "group_subscriptions", ["deleted_at"], name: "index_group_subscriptions_on_deleted_at", using: :btree
  add_index "group_subscriptions", ["discount_id"], name: "index_group_subscriptions_on_discount_id", using: :btree
  add_index "group_subscriptions", ["education_form_id"], name: "index_group_subscriptions_on_education_form_id", using: :btree
  add_index "group_subscriptions", ["group_id", "student_id"], name: "index_group_subscriptions_on_group_id_and_student_id", unique: true, using: :btree
  add_index "group_subscriptions", ["group_price_id"], name: "index_group_subscriptions_on_group_price_id", using: :btree
  add_index "group_subscriptions", ["module_group_id"], name: "index_group_subscriptions_on_module_group_id", using: :btree
  add_index "group_subscriptions", ["practice_basis_id"], name: "index_group_subscriptions_on_practice_basis_id", using: :btree
  add_index "group_subscriptions", ["promotion_id"], name: "index_group_subscriptions_on_promotion_id", using: :btree
  add_index "group_subscriptions", ["shop_id"], name: "index_group_subscriptions_on_shop_id", using: :btree

  create_table "group_transfers", force: :cascade do |t|
    t.integer  "new_group_id"
    t.integer  "old_group_id"
    t.integer  "group_subscription_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "groups", force: :cascade do |t|
    t.text     "title"
    t.integer  "course_id"
    t.integer  "instructor_id"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.date     "begin_on",                                                  null: false
    t.date     "end_on",                                                    null: false
    t.integer  "distances_place",           default: 0,                     null: false
    t.integer  "distances_count",           default: 0,                     null: false
    t.integer  "academics_place",           default: 0,                     null: false
    t.integer  "academics_count",           default: 0,                     null: false
    t.time     "start_time",                default: '2000-01-01 09:00:00', null: false
    t.time     "end_time",                  default: '2000-01-01 13:00:00', null: false
    t.date     "academic_on"
    t.text     "schedule_type",             default: "specific_days",       null: false
    t.datetime "shift_work_on"
    t.text     "schedule_description"
    t.text     "week_days"
    t.datetime "deleted_at"
    t.boolean  "active",                    default: false,                 null: false
    t.datetime "itec"
    t.boolean  "fake",                      default: false
    t.boolean  "places_over_notified",      default: false,                 null: false
    t.integer  "shop_id"
    t.boolean  "scheduled",                 default: false,                 null: false
    t.text     "webinar_link"
    t.boolean  "webinar_notification_sent", default: false,                 null: false
    t.string   "practice_address"
  end

  add_index "groups", ["course_id"], name: "index_groups_on_course_id", using: :btree
  add_index "groups", ["instructor_id"], name: "index_groups_on_instructor_id", using: :btree
  add_index "groups", ["shop_id"], name: "index_groups_on_shop_id", using: :btree

  create_table "history_events", force: :cascade do |t|
    t.text     "title"
    t.text     "year"
    t.text     "description"
    t.text     "image"
    t.integer  "position",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "history_events", ["shop_id"], name: "index_history_events_on_shop_id", using: :btree

  create_table "holidays", force: :cascade do |t|
    t.integer  "year",       null: false
    t.date     "day",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "holidays", ["day"], name: "index_holidays_on_day", unique: true, using: :btree
  add_index "holidays", ["year"], name: "index_holidays_on_year", using: :btree

  create_table "html_items", force: :cascade do |t|
    t.string   "page"
    t.text     "title"
    t.text     "description"
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "shop_id"
  end

  add_index "html_items", ["shop_id"], name: "index_html_items_on_shop_id", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "institution_blocks", force: :cascade do |t|
    t.text     "code"
    t.text     "video_url"
    t.text     "content"
    t.text     "link"
    t.text     "link_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institution_images", force: :cascade do |t|
    t.text     "image"
    t.text     "name"
    t.integer  "institution_block_id"
    t.integer  "position",             default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institution_images", ["institution_block_id"], name: "index_institution_images_on_institution_block_id", using: :btree

  create_table "instructor_faculties", force: :cascade do |t|
    t.integer  "instructor_id"
    t.integer  "faculty_id"
    t.integer  "position",      default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "instructor_faculties", ["faculty_id"], name: "index_instructor_faculties_on_faculty_id", using: :btree
  add_index "instructor_faculties", ["instructor_id"], name: "index_instructor_faculties_on_instructor_id", using: :btree

  create_table "instructor_homes", force: :cascade do |t|
    t.text     "description"
    t.boolean  "active",        default: false, null: false
    t.integer  "instructor_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "instructor_vacations", force: :cascade do |t|
    t.integer  "instructor_id"
    t.date     "begin_on",      null: false
    t.date     "end_on",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "instructor_vacations", ["instructor_id"], name: "index_instructor_vacations_on_instructor_id", using: :btree

  create_table "instructor_works", force: :cascade do |t|
    t.integer  "instructor_id"
    t.integer  "work_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "instructor_works", ["instructor_id", "work_id"], name: "index_instructor_works_on_instructor_id_and_work_id", unique: true, using: :btree
  add_index "instructor_works", ["instructor_id"], name: "index_instructor_works_on_instructor_id", using: :btree
  add_index "instructor_works", ["work_id"], name: "index_instructor_works_on_work_id", using: :btree

  create_table "item_videos", force: :cascade do |t|
    t.integer  "uploaded_video_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "lectures", force: :cascade do |t|
    t.text     "description"
    t.integer  "time"
    t.integer  "block_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "lecture_link"
    t.text     "video_link"
    t.integer  "position"
    t.integer  "term"
    t.text     "pdf"
    t.text     "pdf_status"
    t.boolean  "read_before_practice", default: false, null: false
  end

  add_index "lectures", ["block_id"], name: "index_lectures_on_block_id", using: :btree
  add_index "lectures", ["position"], name: "index_lectures_on_position", using: :btree

  create_table "letters", force: :cascade do |t|
    t.text     "folder",                        null: false
    t.text     "subject"
    t.text     "body"
    t.boolean  "read",          default: false, null: false
    t.datetime "sent_at",                       null: false
    t.integer  "student_id",                    null: false
    t.integer  "instructor_id",                 null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "uid"
    t.text     "message_id",                    null: false
  end

  add_index "letters", ["instructor_id"], name: "index_letters_on_instructor_id", using: :btree
  add_index "letters", ["message_id"], name: "index_letters_on_message_id", unique: true, using: :btree
  add_index "letters", ["student_id"], name: "index_letters_on_student_id", using: :btree

  create_table "linked_discounts", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "discount_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "linked_discounts", ["discount_id"], name: "index_linked_discounts_on_discount_id", using: :btree
  add_index "linked_discounts", ["parent_id", "discount_id"], name: "index_linked_discounts_on_parent_id_and_discount_id", unique: true, using: :btree
  add_index "linked_discounts", ["parent_id"], name: "index_linked_discounts_on_parent_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "editor_id"
    t.integer  "action_type"
    t.text     "description"
    t.integer  "loggerable_id"
    t.string   "loggerable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "logs", ["loggerable_type", "loggerable_id"], name: "index_logs_on_loggerable_type_and_loggerable_id", using: :btree

  create_table "lookups", force: :cascade do |t|
    t.text     "code",       null: false
    t.text     "value"
    t.text     "type_code",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "pdf"
    t.text     "pdf_status"
    t.string   "category"
    t.text     "file"
    t.integer  "shop_id"
    t.text     "url"
  end

  add_index "lookups", ["code", "shop_id"], name: "index_lookups_on_code_and_shop_id", unique: true, using: :btree
  add_index "lookups", ["shop_id"], name: "index_lookups_on_shop_id", using: :btree
  add_index "lookups", ["type_code"], name: "index_lookups_on_type_code", using: :btree

  create_table "magazine_payment_types", force: :cascade do |t|
    t.text     "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailing_journals", force: :cascade do |t|
    t.string   "mailing_title"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "mailing_journals", ["mailing_title"], name: "index_mailing_journals_on_mailing_title", using: :btree
  add_index "mailing_journals", ["user_id"], name: "index_mailing_journals_on_user_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.integer  "lecture_id"
    t.text     "name"
    t.integer  "time"
    t.text     "link"
    t.boolean  "required",   default: false, null: false
    t.integer  "position"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "preview"
    t.text     "file_name"
    t.text     "type",                       null: false
    t.text     "pdf"
    t.text     "pdf_status"
  end

  add_index "materials", ["lecture_id"], name: "index_materials_on_lecture_id", using: :btree
  add_index "materials", ["position"], name: "index_materials_on_position", using: :btree

  create_table "meta_tags", force: :cascade do |t|
    t.text     "identifier",                  null: false
    t.text     "site",           default: "", null: false
    t.text     "title",          default: "", null: false
    t.text     "description",    default: "", null: false
    t.text     "image"
    t.text     "url"
    t.text     "keywords"
    t.text     "og_title"
    t.text     "og_description"
    t.text     "og_image"
    t.text     "og_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "meta_tags", ["identifier", "shop_id"], name: "index_meta_tags_on_identifier_and_shop_id", unique: true, using: :btree
  add_index "meta_tags", ["shop_id"], name: "index_meta_tags_on_shop_id", using: :btree

  create_table "module_groups", force: :cascade do |t|
    t.integer  "amo_module_id"
    t.integer  "course_id"
    t.integer  "group_id"
    t.integer  "group_subscription_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "module_groups", ["amo_module_id"], name: "index_module_groups_on_amo_module_id", using: :btree
  add_index "module_groups", ["course_id"], name: "index_module_groups_on_course_id", using: :btree
  add_index "module_groups", ["group_id"], name: "index_module_groups_on_group_id", using: :btree
  add_index "module_groups", ["group_subscription_id"], name: "index_module_groups_on_group_subscription_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "notable_id"
    t.string   "notable_type"
    t.datetime "noted_at"
    t.text     "amocrm_id"
    t.integer  "note_type"
    t.text     "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "notes", ["notable_type", "notable_id"], name: "index_notes_on_notable_type_and_notable_id", using: :btree

  create_table "notice_attachments", force: :cascade do |t|
    t.integer  "notice_id"
    t.text     "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notice_attachments", ["notice_id"], name: "index_notice_attachments_on_notice_id", using: :btree

  create_table "notice_groups", force: :cascade do |t|
    t.integer  "notice_id"
    t.integer  "group_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "notice_groups", ["group_id"], name: "index_notice_groups_on_group_id", using: :btree
  add_index "notice_groups", ["notice_id", "group_id"], name: "index_notice_groups_on_notice_id_and_group_id", unique: true, using: :btree
  add_index "notice_groups", ["notice_id"], name: "index_notice_groups_on_notice_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.text     "message"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "notice_emails", default: [],              array: true
  end

  create_table "old_urls", force: :cascade do |t|
    t.text     "url",        null: false
    t.text     "new_url",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_group_subscriptions", force: :cascade do |t|
    t.integer  "group_subscription_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",              default: 0, null: false
  end

  add_index "order_group_subscriptions", ["group_subscription_id"], name: "index_order_group_subscriptions_on_group_subscription_id", using: :btree
  add_index "order_group_subscriptions", ["order_id"], name: "index_order_group_subscriptions_on_order_id", using: :btree
  add_index "order_group_subscriptions", ["position"], name: "index_order_group_subscriptions_on_position", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "promo_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "status"
    t.boolean  "cart",          default: false
    t.boolean  "full",          default: false
    t.string   "payment_type"
    t.integer  "shop_id"
  end

  add_index "orders", ["promo_code_id"], name: "index_orders_on_promo_code_id", using: :btree
  add_index "orders", ["shop_id"], name: "index_orders_on_shop_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.text     "image",       null: false
    t.text     "title",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.integer  "shop_id"
    t.string   "url"
  end

  add_index "partners", ["shop_id"], name: "index_partners_on_shop_id", using: :btree

  create_table "payment_logs", force: :cascade do |t|
    t.date     "payed_on"
    t.float    "amount"
    t.text     "payment_type"
    t.text     "appointment"
    t.text     "comment"
    t.integer  "group_id"
    t.integer  "student_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "order_id"
    t.integer  "magazine_payment_type_id"
  end

  add_index "payment_logs", ["group_id"], name: "index_payment_logs_on_group_id", using: :btree
  add_index "payment_logs", ["magazine_payment_type_id"], name: "index_payment_logs_on_magazine_payment_type_id", using: :btree
  add_index "payment_logs", ["order_id"], name: "index_payment_logs_on_order_id", using: :btree
  add_index "payment_logs", ["student_id"], name: "index_payment_logs_on_student_id", using: :btree

  create_table "payment_requisites", force: :cascade do |t|
    t.integer  "group_subscription_id"
    t.text     "name"
    t.text     "address"
    t.text     "inn"
    t.text     "kpp"
    t.text     "account"
    t.text     "bik"
    t.text     "bank"
    t.text     "correspondent_account"
    t.text     "phone"
    t.text     "email"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "position"
    t.text     "position_name"
    t.text     "legal_address"
    t.text     "position_genitive"
    t.text     "based"
  end

  add_index "payment_requisites", ["group_subscription_id"], name: "index_payment_requisites_on_group_subscription_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "group_subscription_id"
    t.float    "amount",                default: 0.0, null: false
    t.date     "payed_on"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "payments", ["group_subscription_id"], name: "index_payments_on_group_subscription_id", using: :btree

  create_table "pdf_images", force: :cascade do |t|
    t.integer  "imagable_id"
    t.string   "imagable_type"
    t.text     "image"
    t.integer  "position",      default: 0, null: false
    t.integer  "integer",       default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "pdf_images", ["imagable_type", "imagable_id"], name: "index_pdf_images_on_imagable_type_and_imagable_id", using: :btree

  create_table "personal_notices", force: :cascade do |t|
    t.text     "message"
    t.boolean  "read",       default: false, null: false
    t.integer  "student_id"
    t.integer  "lecture_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "personal_notices", ["lecture_id"], name: "index_personal_notices_on_lecture_id", using: :btree
  add_index "personal_notices", ["student_id"], name: "index_personal_notices_on_student_id", using: :btree

  create_table "post_categories", force: :cascade do |t|
    t.text     "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "slug"
  end

  add_index "post_categories", ["title"], name: "index_post_categories_on_title", unique: true, using: :btree

  create_table "post_category_links", force: :cascade do |t|
    t.integer  "post_category_id"
    t.integer  "post_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "post_category_links", ["post_category_id"], name: "index_post_category_links_on_post_category_id", using: :btree
  add_index "post_category_links", ["post_id"], name: "index_post_category_links_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "title"
    t.text     "announcement"
    t.text     "text"
    t.boolean  "published",          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "announcement_image"
    t.integer  "impressions_count",  default: 0,     null: false
    t.text     "slug"
    t.text     "slider_image"
    t.boolean  "notified",           default: false, null: false
    t.boolean  "delta",              default: true,  null: false
    t.text     "inner_image"
    t.integer  "shop_id"
  end

  add_index "posts", ["shop_id"], name: "index_posts_on_shop_id", using: :btree

  create_table "practice_bases", force: :cascade do |t|
    t.text     "title",                 null: false
    t.text     "address"
    t.text     "inn"
    t.text     "kpp"
    t.text     "account"
    t.text     "bik"
    t.text     "bank"
    t.text     "correspondent_account"
    t.text     "phone"
    t.text     "email"
    t.text     "medical_license"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "legal_address"
  end

  create_table "practices", force: :cascade do |t|
    t.date     "begin_on",   null: false
    t.date     "end_on"
    t.time     "start_time", null: false
    t.time     "end_time",   null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "practices", ["group_id"], name: "index_practices_on_group_id", using: :btree

  create_table "procedure_requests", force: :cascade do |t|
    t.text     "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "cosmetology_procedure_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "procedure_requests", ["cosmetology_procedure_id"], name: "index_procedure_requests_on_cosmetology_procedure_id", using: :btree

  create_table "promo_codes", force: :cascade do |t|
    t.text     "code"
    t.integer  "discount_id"
    t.date     "end_date"
    t.boolean  "reusable",     default: false
    t.boolean  "extinguished", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promo_codes", ["discount_id"], name: "index_promo_codes_on_discount_id", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.text     "title"
    t.text     "announce"
    t.text     "image"
    t.text     "link"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "promotions", ["shop_id"], name: "index_promotions_on_shop_id", using: :btree

  create_table "question_answers", force: :cascade do |t|
    t.text     "title"
    t.integer  "question_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_answers", ["question_id"], name: "index_question_answers_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "title"
    t.text     "image"
    t.integer  "task_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["task_id"], name: "index_questions_on_task_id", using: :btree

  create_table "recalls", force: :cascade do |t|
    t.text     "file"
    t.text     "video_link"
    t.text     "message",                      null: false
    t.text     "author_name",                  null: false
    t.text     "author_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "video_image"
    t.boolean  "show_on_main", default: false, null: false
    t.text     "directions"
    t.boolean  "lock_on_top",  default: false
    t.integer  "shop_id"
  end

  add_index "recalls", ["shop_id"], name: "index_recalls_on_shop_id", using: :btree

  create_table "rejected_subscriptions", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.text     "notification_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "rejected_subscriptions", ["notification_type"], name: "index_rejected_subscriptions_on_notification_type", using: :btree
  add_index "rejected_subscriptions", ["user_id"], name: "index_rejected_subscriptions_on_user_id", using: :btree

  create_table "result_connection_items", force: :cascade do |t|
    t.integer  "result_id"
    t.integer  "column_id"
    t.integer  "column_variant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "result_connection_items", ["column_id"], name: "index_result_connection_items_on_column_id", using: :btree
  add_index "result_connection_items", ["column_variant_id"], name: "index_result_connection_items_on_column_variant_id", using: :btree
  add_index "result_connection_items", ["result_id"], name: "index_result_connection_items_on_result_id", using: :btree

  create_table "result_file_items", force: :cascade do |t|
    t.text     "file"
    t.integer  "result_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "result_file_items", ["result_id"], name: "index_result_file_items_on_result_id", using: :btree

  create_table "result_test_items", force: :cascade do |t|
    t.integer  "result_id"
    t.integer  "question_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.text     "question_title"
    t.text     "question_answer_title"
    t.text     "correct_answer_title"
  end

  add_index "result_test_items", ["question_answer_id"], name: "index_result_test_items_on_question_answer_id", using: :btree
  add_index "result_test_items", ["question_id"], name: "index_result_test_items_on_question_id", using: :btree
  add_index "result_test_items", ["result_id"], name: "index_result_test_items_on_result_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.text     "type",                          null: false
    t.integer  "instructor_id"
    t.integer  "student_id"
    t.integer  "task_id"
    t.text     "status",                        null: false
    t.text     "answer"
    t.boolean  "passed",        default: false, null: false
    t.integer  "mark"
    t.datetime "marked_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "comment"
  end

  add_index "results", ["instructor_id"], name: "index_results_on_instructor_id", using: :btree
  add_index "results", ["student_id"], name: "index_results_on_student_id", using: :btree
  add_index "results", ["task_id"], name: "index_results_on_task_id", using: :btree

  create_table "scans", force: :cascade do |t|
    t.integer  "work_result_id"
    t.text     "file"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "scans", ["work_result_id"], name: "index_scans_on_work_result_id", using: :btree

  create_table "schedule_item_groups", force: :cascade do |t|
    t.integer  "schedule_item_id"
    t.integer  "group_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "schedule_item_groups", ["group_id"], name: "index_schedule_item_groups_on_group_id", using: :btree
  add_index "schedule_item_groups", ["schedule_item_id"], name: "index_schedule_item_groups_on_schedule_item_id", using: :btree

  create_table "schedule_item_working_off_lists", force: :cascade do |t|
    t.integer  "schedule_item_id"
    t.integer  "working_off_list_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "schedule_item_working_off_lists", ["schedule_item_id"], name: "index_schedule_item_working_off_lists_on_schedule_item_id", using: :btree
  add_index "schedule_item_working_off_lists", ["working_off_list_id"], name: "index_schedule_item_working_off_lists_on_working_off_list_id", using: :btree

  create_table "schedule_items", force: :cascade do |t|
    t.integer  "classroom_id"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.date     "day"
    t.integer  "work_id"
    t.integer  "work_index",    default: 0,     null: false
    t.integer  "instructor_id"
    t.boolean  "approved",      default: false, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "schedule_items", ["classroom_id"], name: "index_schedule_items_on_classroom_id", using: :btree
  add_index "schedule_items", ["instructor_id"], name: "index_schedule_items_on_instructor_id", using: :btree
  add_index "schedule_items", ["work_id"], name: "index_schedule_items_on_work_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.text     "title"
    t.string   "price"
    t.string   "units"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.text     "title",      null: false
    t.text     "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "similar_articles", force: :cascade do |t|
    t.integer  "similar_id"
    t.integer  "article_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "similar_articles", ["article_id"], name: "index_similar_articles_on_article_id", using: :btree
  add_index "similar_articles", ["position"], name: "index_similar_articles_on_position", using: :btree
  add_index "similar_articles", ["similar_id"], name: "index_similar_articles_on_similar_id", using: :btree

  create_table "similar_courses", force: :cascade do |t|
    t.integer  "similar_id"
    t.integer  "course_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "similar_courses", ["course_id"], name: "index_similar_courses_on_course_id", using: :btree
  add_index "similar_courses", ["position"], name: "index_similar_courses_on_position", using: :btree
  add_index "similar_courses", ["similar_id"], name: "index_similar_courses_on_similar_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.text     "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "sms", force: :cascade do |t|
    t.text     "number"
    t.text     "text"
    t.integer  "message_id"
    t.text     "status"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "user_id"
    t.integer  "group_subscription_id"
  end

  add_index "sms", ["group_subscription_id"], name: "index_sms_on_group_subscription_id", using: :btree
  add_index "sms", ["user_id"], name: "index_sms_on_user_id", using: :btree

  create_table "specialities", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "slug",                               null: false
    t.text     "announcement"
    t.string   "icon"
    t.text     "meta_title"
    t.text     "meta_description"
    t.text     "genitive_form"
    t.integer  "shop_id"
    t.text     "page_title"
    t.text     "meta_og_title"
    t.text     "meta_og_description"
    t.boolean  "show_on_site",        default: true, null: false
    t.boolean  "for_main",            default: true, null: false
    t.integer  "level",               default: 0,    null: false
    t.text     "block1"
    t.text     "header2"
    t.text     "block2"
  end

  add_index "specialities", ["parent_id"], name: "index_specialities_on_parent_id", using: :btree
  add_index "specialities", ["shop_id"], name: "index_specialities_on_shop_id", using: :btree

  create_table "square_banners", force: :cascade do |t|
    t.boolean  "active",       default: false, null: false
    t.text     "desktop_text",                 null: false
    t.text     "mobile_text",                  null: false
    t.text     "image"
    t.text     "mobile_image"
    t.text     "btn_title"
    t.text     "link"
    t.integer  "shop_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "square_banners", ["shop_id"], name: "index_square_banners_on_shop_id", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.text     "title",                      null: false
    t.text     "content"
    t.text     "slug",                       null: false
    t.boolean  "permanent",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "static_pages", ["slug"], name: "index_static_pages_on_slug", unique: true, using: :btree

  create_table "student_documents", force: :cascade do |t|
    t.text     "title"
    t.text     "document_type"
    t.text     "file"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "loaded_by_user", default: false
  end

  add_index "student_documents", ["user_id"], name: "index_student_documents_on_user_id", using: :btree

  create_table "student_work_results", force: :cascade do |t|
    t.integer  "work_result_id"
    t.integer  "student_id"
    t.boolean  "absent",         default: true,  null: false
    t.boolean  "passed",         default: false, null: false
    t.integer  "content"
    t.integer  "typography"
    t.integer  "protection"
    t.integer  "total"
    t.integer  "presence"
    t.integer  "customer_care"
    t.integer  "hygiene"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "ergonomic"
  end

  add_index "student_work_results", ["student_id"], name: "index_student_work_results_on_student_id", using: :btree
  add_index "student_work_results", ["work_result_id"], name: "index_student_work_results_on_work_result_id", using: :btree

  create_table "subscription_documents", force: :cascade do |t|
    t.integer  "group_subscription_id",                           null: false
    t.integer  "education_document_id",                           null: false
    t.date     "issued_at"
    t.integer  "registration_number",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "document"
    t.text     "first_appendix"
    t.text     "second_appendix"
    t.boolean  "ready_to_issue",                  default: false
    t.boolean  "issued",                          default: false
    t.string   "blank_number"
    t.integer  "course_id"
    t.boolean  "decline_first_name",              default: true,  null: false
    t.boolean  "decline_last_name",               default: true,  null: false
    t.boolean  "decline_middle_name",             default: true,  null: false
  end

  add_index "subscription_documents", ["course_id"], name: "index_subscription_documents_on_course_id", using: :btree
  add_index "subscription_documents", ["education_document_id"], name: "index_subscription_documents_on_education_document_id", using: :btree
  add_index "subscription_documents", ["group_subscription_id"], name: "index_subscription_documents_on_group_subscription_id", using: :btree
  add_index "subscription_documents", ["registration_number"], name: "index_subscription_documents_on_registration_number", unique: true, using: :btree

  create_table "survey_answers", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "survey_response_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "important",          default: false, null: false
  end

  add_index "survey_answers", ["survey_response_id"], name: "index_survey_answers_on_survey_response_id", using: :btree

  create_table "survey_responses", force: :cascade do |t|
    t.integer  "total_time"
    t.string   "surveymonkey_id"
    t.string   "ip"
    t.text     "analyze_url"
    t.datetime "modified_at"
    t.integer  "group_subscription_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "survey_responses", ["group_subscription_id"], name: "index_survey_responses_on_group_subscription_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.text     "type"
    t.text     "title"
    t.text     "description"
    t.text     "answer"
    t.integer  "lecture_id"
    t.integer  "max_answer_length"
    t.integer  "max_attempts_count"
    t.integer  "time_limit"
    t.integer  "items_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "final",              default: false, null: false
  end

  add_index "tasks", ["lecture_id"], name: "index_tasks_on_lecture_id", using: :btree

  create_table "unisender_results", force: :cascade do |t|
    t.text     "email"
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploaded_videos", force: :cascade do |t|
    t.text     "title",         null: false
    t.text     "preview_image"
    t.text     "file"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "jw_script"
  end

  create_table "used_times", force: :cascade do |t|
    t.date     "date"
    t.time     "time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "consultation_id"
  end

  add_index "used_times", ["consultation_id"], name: "index_used_times_on_consultation_id", using: :btree
  add_index "used_times", ["date", "time"], name: "index_used_times_on_date_and_time", unique: true, using: :btree
  add_index "used_times", ["date"], name: "index_used_times_on_date", using: :btree

  create_table "user_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "title",                                null: false
    t.text     "description",                          null: false
    t.datetime "last_tracked_at",                      null: false
    t.integer  "spent_time",      default: 0,          null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.text     "event_type",      default: "learning", null: false
  end

  add_index "user_activities", ["last_tracked_at"], name: "index_user_activities_on_last_tracked_at", using: :btree
  add_index "user_activities", ["trackable_type", "trackable_id"], name: "index_user_activities_on_trackable_type_and_trackable_id", using: :btree
  add_index "user_activities", ["user_id", "title", "description"], name: "user_activity_index", using: :btree
  add_index "user_activities", ["user_id"], name: "index_user_activities_on_user_id", using: :btree

  create_table "user_phones", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_questions", force: :cascade do |t|
    t.text     "user_name",  null: false
    t.text     "email",      null: false
    t.text     "question",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_total_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "last_tracked_at",              null: false
    t.integer  "spent_time",       default: 0, null: false
    t.integer  "today_spent_time", default: 0, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "user_total_activities", ["user_id"], name: "index_user_total_activities_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "type"
    t.string   "email",                     default: "",     null: false
    t.string   "encrypted_password",        default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "first_name"
    t.text     "last_name"
    t.boolean  "delta",                     default: true,   null: false
    t.text     "avatar"
    t.boolean  "demo",                      default: false,  null: false
    t.boolean  "hide_tutorial",             default: false,  null: false
    t.text     "encrypted_email_password"
    t.text     "middle_name"
    t.date     "birthday"
    t.text     "translit_name"
    t.text     "phones",                    default: [],                  array: true
    t.text     "emails",                    default: [],                  array: true
    t.integer  "education_level_id"
    t.text     "passport_series"
    t.text     "passport_number"
    t.date     "passport_issued_on"
    t.text     "passport_organisation"
    t.text     "passport_address"
    t.text     "address"
    t.text     "amocrm_id"
    t.boolean  "imported_from_amo",         default: false,  null: false
    t.datetime "welcome_sent_at"
    t.text     "comagic_campaign"
    t.integer  "update_job_id"
    t.text     "wear_size"
    t.integer  "version",                   default: 0,      null: false
    t.integer  "campaign_id"
    t.datetime "amo_created_at"
    t.text     "description"
    t.boolean  "subscribed_on_blog",        default: false
    t.integer  "wordpress_id"
    t.datetime "phone_added_at"
    t.datetime "deleted_at"
    t.integer  "shop_id"
    t.boolean  "privacy_policy_confirmed",  default: false,  null: false
    t.boolean  "notified_about_requisites", default: false,  null: false
    t.string   "source",                    default: "none", null: false
  end

  add_index "users", ["amocrm_id", "email", "emails", "phones"], name: "index_users_on_amocrm_id_and_email_and_emails_and_phones", using: :btree
  add_index "users", ["campaign_id"], name: "index_users_on_campaign_id", using: :btree
  add_index "users", ["education_level_id"], name: "index_users_on_education_level_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["shop_id"], name: "index_users_on_shop_id", using: :btree

  create_table "vacancies", force: :cascade do |t|
    t.text     "name",                         null: false
    t.text     "content_type",                 null: false
    t.text     "content"
    t.text     "file"
    t.integer  "vacancy_group_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",         default: 0
  end

  add_index "vacancies", ["vacancy_group_id"], name: "index_vacancies_on_vacancy_group_id", using: :btree

  create_table "vacancy_groups", force: :cascade do |t|
    t.text     "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_classrooms", force: :cascade do |t|
    t.integer  "work_id"
    t.integer  "classroom_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "work_classrooms", ["classroom_id"], name: "index_work_classrooms_on_classroom_id", using: :btree
  add_index "work_classrooms", ["work_id", "classroom_id"], name: "index_work_classrooms_on_work_id_and_classroom_id", unique: true, using: :btree
  add_index "work_classrooms", ["work_id"], name: "index_work_classrooms_on_work_id", using: :btree

  create_table "work_results", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "work_id"
    t.date     "marked_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "work_results", ["group_id"], name: "index_work_results_on_group_id", using: :btree
  add_index "work_results", ["work_id"], name: "index_work_results_on_work_id", using: :btree

  create_table "working_off_lists", force: :cascade do |t|
    t.text    "hours",                                        null: false
    t.text    "variant",                                      null: false
    t.text    "user_file"
    t.date    "processed_on",                                 null: false
    t.integer "work_id"
    t.integer "group_subscription_id"
    t.text    "working_off_type",      default: "not_chosen"
    t.boolean "exam",                  default: false,        null: false
    t.integer "instructor_id"
    t.boolean "scheduled",             default: false,        null: false
  end

  add_index "working_off_lists", ["group_subscription_id"], name: "index_working_off_lists_on_group_subscription_id", using: :btree
  add_index "working_off_lists", ["instructor_id"], name: "index_working_off_lists_on_instructor_id", using: :btree
  add_index "working_off_lists", ["work_id"], name: "index_working_off_lists_on_work_id", using: :btree

  create_table "works", force: :cascade do |t|
    t.text     "title"
    t.text     "appendix"
    t.text     "type"
    t.text     "form_sheet"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "criterion"
    t.integer  "duration",               default: 0, null: false
    t.integer  "break_days",             default: 0, null: false
    t.text     "hairdresser_form_sheet"
    t.text     "statement_criterion"
  end

  add_foreign_key "about_images", "shops"
  add_foreign_key "amo_module_courses", "amo_modules"
  add_foreign_key "amo_module_courses", "courses"
  add_foreign_key "amocrm_pipelines", "shops"
  add_foreign_key "amocrm_statuses", "amocrm_pipelines"
  add_foreign_key "api_keys", "users"
  add_foreign_key "articles", "shops"
  add_foreign_key "attachments", "letters"
  add_foreign_key "authentications", "users"
  add_foreign_key "automatic_discounts", "discounts"
  add_foreign_key "banners", "shops"
  add_foreign_key "blocks", "shops"
  add_foreign_key "blog_categories", "articles"
  add_foreign_key "blog_categories", "categories"
  add_foreign_key "blog_categories", "shops"
  add_foreign_key "blog_courses", "articles"
  add_foreign_key "blog_courses", "courses"
  add_foreign_key "blog_square_banners", "articles"
  add_foreign_key "blog_square_banners", "square_banners"
  add_foreign_key "blog_subscribers", "users"
  add_foreign_key "books", "book_categories"
  add_foreign_key "call_results", "group_subscriptions"
  add_foreign_key "campaign_indices", "campaigns"
  add_foreign_key "categories", "shops"
  add_foreign_key "column_variants", "columns"
  add_foreign_key "columns", "tasks"
  add_foreign_key "consultations", "courses"
  add_foreign_key "cosmetology_procedures", "shops"
  add_foreign_key "course_advantages", "advantages"
  add_foreign_key "course_advantages", "courses"
  add_foreign_key "course_automatic_discounts", "automatic_discounts"
  add_foreign_key "course_automatic_discounts", "courses"
  add_foreign_key "course_blocks", "blocks"
  add_foreign_key "course_blocks", "courses"
  add_foreign_key "course_curriculum_blocks", "courses"
  add_foreign_key "course_curriculum_blocks", "curriculum_blocks"
  add_foreign_key "course_documents", "courses"
  add_foreign_key "course_documents", "education_documents"
  add_foreign_key "course_documents", "education_levels"
  add_foreign_key "course_education_documents", "courses"
  add_foreign_key "course_education_documents", "education_documents"
  add_foreign_key "course_instructors", "courses"
  add_foreign_key "course_instructors", "users", column: "instructor_id"
  add_foreign_key "course_links", "courses"
  add_foreign_key "course_promo_codes", "courses"
  add_foreign_key "course_promo_codes", "promo_codes"
  add_foreign_key "course_recalls", "courses"
  add_foreign_key "course_recalls", "recalls"
  add_foreign_key "course_seos", "courses"
  add_foreign_key "course_skills", "courses"
  add_foreign_key "course_skills", "skills"
  add_foreign_key "course_specialities", "courses"
  add_foreign_key "course_specialities", "specialities"
  add_foreign_key "course_works", "courses"
  add_foreign_key "course_works", "lectures"
  add_foreign_key "course_works", "works"
  add_foreign_key "courses", "amo_modules", column: "additional_amo_module_id"
  add_foreign_key "courses", "faculties"
  add_foreign_key "courses", "groups", column: "nearest_group_id"
  add_foreign_key "courses", "shops"
  add_foreign_key "curriculum_blocks", "shops"
  add_foreign_key "deleted_notices", "notices"
  add_foreign_key "deleted_notices", "users", column: "student_id"
  add_foreign_key "downloads", "lectures"
  add_foreign_key "education_document_pictures", "education_documents"
  add_foreign_key "exercise_results", "exercises"
  add_foreign_key "exercise_results", "student_work_results"
  add_foreign_key "exercises", "exercises", column: "parent_id"
  add_foreign_key "exercises", "works"
  add_foreign_key "expelled_students", "expulsions"
  add_foreign_key "expelled_students", "users", column: "student_id"
  add_foreign_key "expulsions", "groups"
  add_foreign_key "faculties", "shops"
  add_foreign_key "faqs", "shops"
  add_foreign_key "feedback_questions", "lectures"
  add_foreign_key "feedback_questions", "users", column: "instructor_id"
  add_foreign_key "finished_materials", "materials"
  add_foreign_key "finished_materials", "users", column: "student_id"
  add_foreign_key "graduate_faculties", "faculties"
  add_foreign_key "graduate_faculties", "graduates"
  add_foreign_key "graduates", "shops"
  add_foreign_key "group_prices", "education_forms"
  add_foreign_key "group_prices", "groups"
  add_foreign_key "group_subscriptions", "amo_modules"
  add_foreign_key "group_subscriptions", "amocrm_statuses"
  add_foreign_key "group_subscriptions", "discounts"
  add_foreign_key "group_subscriptions", "education_forms"
  add_foreign_key "group_subscriptions", "group_prices"
  add_foreign_key "group_subscriptions", "groups"
  add_foreign_key "group_subscriptions", "module_groups"
  add_foreign_key "group_subscriptions", "practice_bases"
  add_foreign_key "group_subscriptions", "promotions"
  add_foreign_key "group_subscriptions", "shops"
  add_foreign_key "group_subscriptions", "users", column: "student_id"
  add_foreign_key "group_transfers", "group_subscriptions"
  add_foreign_key "groups", "courses"
  add_foreign_key "groups", "shops"
  add_foreign_key "groups", "users", column: "instructor_id"
  add_foreign_key "history_events", "shops"
  add_foreign_key "html_items", "shops"
  add_foreign_key "institution_images", "institution_blocks"
  add_foreign_key "instructor_faculties", "faculties"
  add_foreign_key "instructor_faculties", "users", column: "instructor_id"
  add_foreign_key "instructor_vacations", "users", column: "instructor_id"
  add_foreign_key "instructor_works", "users", column: "instructor_id"
  add_foreign_key "instructor_works", "works"
  add_foreign_key "item_videos", "uploaded_videos"
  add_foreign_key "lectures", "blocks"
  add_foreign_key "letters", "users", column: "instructor_id"
  add_foreign_key "linked_discounts", "discounts"
  add_foreign_key "linked_discounts", "discounts", column: "parent_id"
  add_foreign_key "lookups", "shops"
  add_foreign_key "mailing_journals", "users"
  add_foreign_key "materials", "lectures"
  add_foreign_key "meta_tags", "shops"
  add_foreign_key "module_groups", "amo_modules"
  add_foreign_key "module_groups", "courses"
  add_foreign_key "module_groups", "group_subscriptions"
  add_foreign_key "module_groups", "groups"
  add_foreign_key "notice_attachments", "notices"
  add_foreign_key "notice_groups", "groups"
  add_foreign_key "notice_groups", "notices"
  add_foreign_key "order_group_subscriptions", "group_subscriptions"
  add_foreign_key "order_group_subscriptions", "orders"
  add_foreign_key "orders", "promo_codes"
  add_foreign_key "orders", "shops"
  add_foreign_key "orders", "users"
  add_foreign_key "partners", "shops"
  add_foreign_key "payment_logs", "groups"
  add_foreign_key "payment_logs", "magazine_payment_types"
  add_foreign_key "payment_logs", "users", column: "student_id"
  add_foreign_key "payment_requisites", "group_subscriptions"
  add_foreign_key "payments", "group_subscriptions"
  add_foreign_key "personal_notices", "lectures"
  add_foreign_key "personal_notices", "users", column: "student_id"
  add_foreign_key "post_category_links", "post_categories"
  add_foreign_key "post_category_links", "posts"
  add_foreign_key "posts", "shops"
  add_foreign_key "practices", "groups"
  add_foreign_key "procedure_requests", "cosmetology_procedures"
  add_foreign_key "promo_codes", "discounts"
  add_foreign_key "promotions", "shops"
  add_foreign_key "question_answers", "questions"
  add_foreign_key "questions", "tasks"
  add_foreign_key "recalls", "shops"
  add_foreign_key "rejected_subscriptions", "users"
  add_foreign_key "result_connection_items", "column_variants"
  add_foreign_key "result_connection_items", "columns"
  add_foreign_key "result_connection_items", "results"
  add_foreign_key "result_file_items", "results"
  add_foreign_key "result_test_items", "question_answers"
  add_foreign_key "result_test_items", "questions"
  add_foreign_key "result_test_items", "results"
  add_foreign_key "results", "tasks"
  add_foreign_key "results", "users", column: "student_id"
  add_foreign_key "scans", "work_results"
  add_foreign_key "schedule_item_groups", "groups"
  add_foreign_key "schedule_item_groups", "schedule_items"
  add_foreign_key "schedule_item_working_off_lists", "schedule_items"
  add_foreign_key "schedule_item_working_off_lists", "working_off_lists"
  add_foreign_key "schedule_items", "classrooms"
  add_foreign_key "schedule_items", "users", column: "instructor_id"
  add_foreign_key "schedule_items", "works"
  add_foreign_key "similar_articles", "articles"
  add_foreign_key "similar_articles", "articles", column: "similar_id"
  add_foreign_key "similar_courses", "courses"
  add_foreign_key "similar_courses", "courses", column: "similar_id"
  add_foreign_key "sms", "group_subscriptions"
  add_foreign_key "sms", "users"
  add_foreign_key "specialities", "shops"
  add_foreign_key "specialities", "specialities", column: "parent_id"
  add_foreign_key "square_banners", "shops"
  add_foreign_key "student_documents", "users"
  add_foreign_key "student_work_results", "users", column: "student_id"
  add_foreign_key "student_work_results", "work_results"
  add_foreign_key "subscription_documents", "courses"
  add_foreign_key "subscription_documents", "education_documents"
  add_foreign_key "subscription_documents", "group_subscriptions"
  add_foreign_key "survey_answers", "survey_responses"
  add_foreign_key "survey_responses", "group_subscriptions"
  add_foreign_key "tasks", "lectures"
  add_foreign_key "used_times", "consultations"
  add_foreign_key "user_activities", "users"
  add_foreign_key "user_total_activities", "users"
  add_foreign_key "users", "campaigns"
  add_foreign_key "users", "education_levels"
  add_foreign_key "users", "shops"
  add_foreign_key "vacancies", "vacancy_groups"
  add_foreign_key "work_classrooms", "classrooms"
  add_foreign_key "work_classrooms", "works"
  add_foreign_key "work_results", "groups"
  add_foreign_key "work_results", "works"
  add_foreign_key "working_off_lists", "group_subscriptions"
  add_foreign_key "working_off_lists", "users", column: "instructor_id"
  add_foreign_key "working_off_lists", "works"

  create_view "another_group_places",  sql_definition: <<-SQL
      SELECT row_number() OVER (PARTITION BY t.course_id, t.min_begin_practice_date, t.times, t.schedule ORDER BY t.title) AS group_number,
      t.id,
      t.course_id,
      t.course_short_name,
      t.title,
      t.schedule,
      t.min_begin_practice_date,
      t.dates,
      t.times,
      t.distances_place,
      t.distances_count,
      t.remaining_seats_count
     FROM ( SELECT c.id,
              c.course_id,
              c.course_short_name,
              c.title,
              c.schedule,
              min(c.begin_practice_date) AS min_begin_practice_date,
              string_agg(c.practice_date, '\n'::text) AS dates,
              string_agg(c.practice_time, '\n'::text) AS times,
              c.distances_place,
              c.distances_count,
              (c.distances_place - c.distances_count) AS remaining_seats_count
             FROM ( SELECT btrim(groups.schedule_description) AS schedule,
                      courses.short_name AS course_short_name,
                      practices.begin_on AS begin_practice_date,
                      concat_ws(' - '::text, to_char((practices.begin_on)::timestamp with time zone, 'dd.mm.yy'::text), to_char((practices.end_on)::timestamp with time zone, 'dd.mm.yy'::text)) AS practice_date,
                      concat_ws(' - '::text, to_char((practices.start_time)::interval, 'HH24:MI'::text), to_char((practices.end_time)::interval, 'HH24:MI'::text)) AS practice_time,
                      groups.id,
                      groups.title,
                      groups.course_id,
                      groups.instructor_id,
                      groups.created_at,
                      groups.updated_at,
                      groups.begin_on,
                      groups.end_on,
                      groups.distances_place,
                      groups.distances_count,
                      groups.academics_place,
                      groups.academics_count,
                      groups.start_time,
                      groups.end_time,
                      groups.academic_on,
                      groups.schedule_type,
                      groups.shift_work_on,
                      groups.schedule_description,
                      groups.week_days,
                      groups.deleted_at,
                      groups.active,
                      groups.itec,
                      groups.fake,
                      groups.places_over_notified,
                      groups.shop_id,
                      groups.scheduled
                     FROM ((groups
                       JOIN practices ON ((practices.group_id = groups.id)))
                       JOIN courses ON ((courses.id = groups.course_id)))
                    WHERE ((groups.deleted_at IS NULL) AND (groups.active = true) AND ((practices.begin_on <= ('now'::text)::date) AND (practices.end_on >= ('now'::text)::date)))
                    ORDER BY practices.begin_on, groups.id) c
            GROUP BY c.id, c.title, c.course_id, c.course_short_name, c.schedule, c.distances_place, c.distances_count) t
    ORDER BY t.title;
  SQL

  create_view "group_places",  sql_definition: <<-SQL
      SELECT row_number() OVER (PARTITION BY t.course_id, t.min_begin_practice_date, t.times, t.schedule ORDER BY t.title) AS group_number,
      t.id,
      t.course_id,
      t.course_short_name,
      t.title,
      t.schedule,
      t.min_begin_practice_date,
      t.dates,
      t.times,
      t.distances_place,
      t.distances_count,
      t.remaining_seats_count
     FROM ( SELECT c.id,
              c.course_id,
              c.course_short_name,
              c.title,
              c.schedule,
              min(c.begin_practice_date) AS min_begin_practice_date,
              string_agg(c.practice_date, '\n'::text) AS dates,
              string_agg(c.practice_time, '\n'::text) AS times,
              c.distances_place,
              c.distances_count,
              (c.distances_place - c.distances_count) AS remaining_seats_count
             FROM ( SELECT btrim(groups.schedule_description) AS schedule,
                      courses.short_name AS course_short_name,
                      practices.begin_on AS begin_practice_date,
                      concat_ws(' - '::text, to_char((practices.begin_on)::timestamp with time zone, 'dd.mm.yy'::text), to_char((practices.end_on)::timestamp with time zone, 'dd.mm.yy'::text)) AS practice_date,
                      concat_ws(' - '::text, to_char((practices.start_time)::interval, 'HH24:MI'::text), to_char((practices.end_time)::interval, 'HH24:MI'::text)) AS practice_time,
                      groups.id,
                      groups.title,
                      groups.course_id,
                      groups.instructor_id,
                      groups.created_at,
                      groups.updated_at,
                      groups.begin_on,
                      groups.end_on,
                      groups.distances_place,
                      groups.distances_count,
                      groups.academics_place,
                      groups.academics_count,
                      groups.start_time,
                      groups.end_time,
                      groups.academic_on,
                      groups.schedule_type,
                      groups.shift_work_on,
                      groups.schedule_description,
                      groups.week_days,
                      groups.deleted_at,
                      groups.active,
                      groups.itec,
                      groups.fake,
                      groups.places_over_notified,
                      groups.shop_id,
                      groups.scheduled
                     FROM ((groups
                       JOIN practices ON ((practices.group_id = groups.id)))
                       JOIN courses ON ((courses.id = groups.course_id)))
                    WHERE ((groups.deleted_at IS NULL) AND (groups.active = true) AND (practices.begin_on >= ('now'::text)::date))
                    ORDER BY practices.begin_on, groups.id) c
            GROUP BY c.id, c.title, c.course_id, c.course_short_name, c.schedule, c.distances_place, c.distances_count) t
    ORDER BY t.title;
  SQL

end
