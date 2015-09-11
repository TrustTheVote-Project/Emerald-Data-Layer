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

ActiveRecord::Schema.define(version: 20150911152744) do

  create_table "vssc_ballot_selection_candidate_id_refs", force: :cascade do |t|
    t.integer "ballot_selection_id"
    t.string  "candidate_id_ref"
  end

  add_index "vssc_ballot_selection_candidate_id_refs", ["ballot_selection_id", "candidate_id_ref"], name: "vssc_candidate_selection_candidates"

  create_table "vssc_ballot_selection_endorsement_party_id_refs", force: :cascade do |t|
    t.integer "ballot_selection_id"
    t.string  "party_id_ref"
  end

  add_index "vssc_ballot_selection_endorsement_party_id_refs", ["ballot_selection_id", "party_id_ref"], name: "vssc_candidate_selection_parties"

  create_table "vssc_ballot_selection_party_id_refs", force: :cascade do |t|
    t.integer "ballot_selection_id"
    t.string  "party_id_ref"
  end

  add_index "vssc_ballot_selection_party_id_refs", ["ballot_selection_id", "party_id_ref"], name: "vssc_party_selection_parties"

  create_table "vssc_ballot_selections", force: :cascade do |t|
    t.integer  "contest_id"
    t.string   "type"
    t.string   "object_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "selection_id"
    t.boolean  "is_write_in"
  end

  add_index "vssc_ballot_selections", ["contest_id"], name: "vssc_ballot_selection_contest"
  add_index "vssc_ballot_selections", ["object_id"], name: "vssc_ballot_selection_object_id"
  add_index "vssc_ballot_selections", ["selection_id"], name: "vssc_ballot_measure_selections"

  create_table "vssc_ballot_style_gp_unit_id_refs", force: :cascade do |t|
    t.integer "ballot_style_id"
    t.string  "gp_unit_id_ref"
  end

  add_index "vssc_ballot_style_gp_unit_id_refs", ["gp_unit_id_ref", "ballot_style_id"], name: "vssc_ballot_style_gp_units"

  create_table "vssc_ballot_style_party_id_refs", force: :cascade do |t|
    t.integer "ballot_style_id"
    t.string  "party_id_ref"
  end

  add_index "vssc_ballot_style_party_id_refs", ["party_id_ref", "ballot_style_id"], name: "vssc_ballot_style_parties"

  create_table "vssc_ballot_styles", force: :cascade do |t|
    t.integer  "election_id"
    t.string   "image_uri"
    t.string   "ballot_style_identifier"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "vssc_ballot_styles", ["election_id"], name: "vssc_ballot_style_election"

  create_table "vssc_candidates", force: :cascade do |t|
    t.integer  "election_id"
    t.integer  "ballot_name_id"
    t.string   "party_identifier"
    t.string   "person_identifier"
    t.string   "object_id"
    t.date     "file_date"
    t.string   "candidate_identifier"
    t.boolean  "is_incumbent"
    t.boolean  "is_top_ticket"
    t.string   "post_election_status"
    t.string   "pre_election_status"
    t.integer  "sequence_order"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "vssc_candidates", ["ballot_name_id"], name: "vssc_candidate_ballot_name"
  add_index "vssc_candidates", ["election_id"], name: "vssc_candidate_election"
  add_index "vssc_candidates", ["object_id"], name: "vssc_candidate_object_id"

  create_table "vssc_codes", force: :cascade do |t|
    t.string   "codeable_type"
    t.integer  "codeable_id"
    t.string   "other_type"
    t.string   "code_type"
    t.string   "value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "vssc_codes", ["codeable_type", "codeable_id"], name: "vssc_codeable"

  create_table "vssc_contact_information", force: :cascade do |t|
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.text     "address_line"
    t.text     "email"
    t.text     "fax"
    t.string   "name"
    t.text     "phone"
    t.text     "uri"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "vssc_contact_information", ["contactable_id", "contactable_type"], name: "vssc_contactable"

  create_table "vssc_contest_office_id_refs", force: :cascade do |t|
    t.integer "contest_id"
    t.string  "office_id_ref"
  end

  add_index "vssc_contest_office_id_refs", ["contest_id", "office_id_ref"], name: "vssc_contest_offices"

  create_table "vssc_contests", force: :cascade do |t|
    t.string   "type"
    t.integer  "election_id"
    t.integer  "ballot_sub_title_id"
    t.integer  "ballot_title_id"
    t.string   "jurisdictional_scope_identifier"
    t.string   "name"
    t.string   "object_id"
    t.string   "abbreviation"
    t.boolean  "has_rotation"
    t.string   "other_vote_variation_type"
    t.integer  "sequence_order"
    t.integer  "sub_units_reported"
    t.integer  "total_sub_units"
    t.string   "vote_variation_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "con_statement_id"
    t.integer  "effect_of_abstain_id"
    t.integer  "full_text_id"
    t.integer  "passage_threshold_id"
    t.integer  "pro_statement_id"
    t.integer  "summary_text_id"
    t.string   "other_type"
    t.string   "ballot_measure_type"
    t.string   "primary_party_identifier"
    t.integer  "number_elected"
    t.integer  "votes_allowed"
    t.string   "candidate_identifier"
    t.string   "office_identifier"
  end

  add_index "vssc_contests", ["ballot_sub_title_id"], name: "vssc_contest_ballot_sub_title"
  add_index "vssc_contests", ["ballot_title_id"], name: "vssc_contest_ballot_title"
  add_index "vssc_contests", ["candidate_identifier"], name: "vssc_ret_con_candidate"
  add_index "vssc_contests", ["con_statement_id"], name: "vssc_ballot_measure_con_statement"
  add_index "vssc_contests", ["effect_of_abstain_id"], name: "vssc_ballot_measure_effect_of_abstain"
  add_index "vssc_contests", ["election_id"], name: "vssc_contest_election"
  add_index "vssc_contests", ["full_text_id"], name: "vssc_ballot_measure_full_text"
  add_index "vssc_contests", ["object_id"], name: "vssc_contest_object_id"
  add_index "vssc_contests", ["office_identifier"], name: "vssc_ret_con_office"
  add_index "vssc_contests", ["passage_threshold_id"], name: "vssc_ballot_measure_passage_threshold"
  add_index "vssc_contests", ["primary_party_identifier"], name: "vssc_can_con_primary_party"
  add_index "vssc_contests", ["pro_statement_id"], name: "vssc_ballot_measure_pro_statement"
  add_index "vssc_contests", ["summary_text_id"], name: "vssc_ballot_measure_summary_text"

  create_table "vssc_count_statuses", force: :cascade do |t|
    t.integer  "count_statusable_id"
    t.string   "count_statusable_type"
    t.string   "other_type"
    t.string   "status"
    t.string   "count_item_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "vssc_count_statuses", ["count_statusable_id", "count_statusable_type"], name: "vssc_count_statusable"

  create_table "vssc_counts", force: :cascade do |t|
    t.string   "type"
    t.integer  "countable_id"
    t.string   "countable_type"
    t.integer  "device_id"
    t.string   "gp_unit_identifier"
    t.string   "other_type"
    t.string   "count_item_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "ballots_cast"
    t.integer  "ballots_outstanding"
    t.integer  "ballots_rejected"
    t.integer  "overvotes"
    t.integer  "undervotes"
    t.integer  "write_ins"
    t.integer  "summary_countable_id"
    t.string   "summary_countable_type"
    t.float    "count"
  end

  add_index "vssc_counts", ["countable_id", "countable_type"], name: "vssc_countable"
  add_index "vssc_counts", ["device_id"], name: "vssc_counts_device"
  add_index "vssc_counts", ["gp_unit_identifier"], name: "vssc_counts_gp_unit"
  add_index "vssc_counts", ["summary_countable_id", "summary_countable_type"], name: "vssc_counts_summary_countable"
  add_index "vssc_counts", ["type"], name: "vssc_counts_type"

  create_table "vssc_devices", force: :cascade do |t|
    t.string   "manufacturer"
    t.string   "model"
    t.string   "device_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "vssc_election_reports", force: :cascade do |t|
    t.string   "message"
    t.integer  "election_id"
    t.text     "notes"
    t.string   "format"
    t.datetime "generated_date"
    t.string   "issuer"
    t.string   "issuer_abbreviation"
    t.boolean  "is_test"
    t.integer  "sequence"
    t.integer  "sequence_end"
    t.string   "status"
    t.string   "test_type"
    t.string   "vendor_application_identifier"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "vssc_election_reports", ["election_id"], name: "vssc_election_reports_election"

  create_table "vssc_elections", force: :cascade do |t|
    t.integer  "contact_information_id"
    t.string   "election_scope_identifier"
    t.integer  "name_id"
    t.date     "date"
    t.date     "end_date"
    t.string   "election_type"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "vssc_elections", ["contact_information_id"], name: "vssc_election_contact_information"
  add_index "vssc_elections", ["election_scope_identifier"], name: "vssc_elections_gp_scope"
  add_index "vssc_elections", ["name_id"], name: "vssc_elections_name"

  create_table "vssc_gp_unit_authority_id_refs", force: :cascade do |t|
    t.integer "gp_unit_id"
    t.string  "authority_id_ref"
  end

  add_index "vssc_gp_unit_authority_id_refs", ["gp_unit_id", "authority_id_ref"], name: "vssc_gp_unit_authorities"

  create_table "vssc_gp_unit_composing_gp_unit_id_refs", force: :cascade do |t|
    t.integer "gp_unit_id"
    t.string  "composing_gp_unit_id_ref"
  end

  add_index "vssc_gp_unit_composing_gp_unit_id_refs", ["gp_unit_id", "composing_gp_unit_id_ref"], name: "vssc_gp_unit_composing_units"

  create_table "vssc_gp_units", force: :cascade do |t|
    t.string   "type"
    t.integer  "election_report_id"
    t.string   "object_id"
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "device_id"
    t.string   "serial_number"
    t.integer  "contact_information_id"
    t.text     "count_statuses"
    t.integer  "spatial_dimension_id"
    t.boolean  "is_electoral_district"
    t.string   "other_type"
    t.integer  "sub_units_reported"
    t.integer  "total_sub_units"
    t.string   "reporting_unit_type"
    t.integer  "voters_participated"
    t.integer  "voters_registered"
  end

  add_index "vssc_gp_units", ["contact_information_id"], name: "vssc_gp_unit_contact_info"
  add_index "vssc_gp_units", ["election_report_id"], name: "vscc_gp_unit_election_report"
  add_index "vssc_gp_units", ["object_id"], name: "vssc_gp_unit_object_id"
  add_index "vssc_gp_units", ["spatial_dimension_id"], name: "vssc_gp_unit_spatial_dimension"
  add_index "vssc_gp_units", ["type"], name: "vssc_gp_unit_type"

  create_table "vssc_hours", force: :cascade do |t|
    t.integer  "hourable_id"
    t.string   "hourable_type"
    t.string   "day"
    t.datetime "end_time"
    t.datetime "start_time"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "vssc_hours", ["hourable_id", "hourable_type"], name: "vssc_hourable"

  create_table "vssc_internationalized_texts", force: :cascade do |t|
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vssc_language_strings", force: :cascade do |t|
    t.integer  "internationalized_text_id"
    t.string   "language"
    t.text     "text"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "vssc_language_strings", ["internationalized_text_id"], name: "vssc_language_string_internationalized_text"

  create_table "vssc_office_group_office_ids", force: :cascade do |t|
    t.integer "office_id"
    t.string  "office_id_ref"
  end

  add_index "vssc_office_group_office_ids", ["office_id", "office_id_ref"], name: "vssc_office_group_office_refs"

  create_table "vssc_office_groups", force: :cascade do |t|
    t.integer  "office_groupable_id"
    t.string   "office_groupable_type"
    t.string   "name"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "vssc_office_groups", ["office_groupable_id", "office_groupable_type"], name: "vssc_office_groupable"

  create_table "vssc_office_office_holder_id_refs", force: :cascade do |t|
    t.integer "office_id"
    t.string  "office_holder_id_ref"
  end

  add_index "vssc_office_office_holder_id_refs", ["office_id", "office_holder_id_ref"], name: "vssc_office_office_holder_ref"

  create_table "vssc_offices", force: :cascade do |t|
    t.integer  "office_group_id"
    t.integer  "election_report_id"
    t.integer  "contact_information_id"
    t.string   "jurisdictional_scope_identifier"
    t.integer  "name_id"
    t.integer  "term_id"
    t.string   "object_id"
    t.datetime "filing_deadline"
    t.boolean  "is_partisan"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "vssc_offices", ["contact_information_id"], name: "vssc_office_contact_information"
  add_index "vssc_offices", ["election_report_id"], name: "vssc_office_election_report"
  add_index "vssc_offices", ["jurisdictional_scope_identifier"], name: "vssc_office_jurisdiction_scope"
  add_index "vssc_offices", ["name_id"], name: "vssc_office_name"
  add_index "vssc_offices", ["object_id"], name: "vssc_office_object_id"
  add_index "vssc_offices", ["office_group_id"], name: "vssc_office_office_group"
  add_index "vssc_offices", ["term_id"], name: "vssc_office_term"

  create_table "vssc_ordered_contest_ballot_selection_id_refs", force: :cascade do |t|
    t.integer "ordered_contest_id"
    t.string  "ballot_selection_id_ref"
  end

  add_index "vssc_ordered_contest_ballot_selection_id_refs", ["ordered_contest_id", "ballot_selection_id_ref"], name: "vssc_ordered_contest_ballot_selection_ref"

  create_table "vssc_ordered_contests", force: :cascade do |t|
    t.integer  "ballot_style_id"
    t.string   "contest_identifier"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "vssc_ordered_contests", ["ballot_style_id"], name: "vscc_ordered_contest_ballot_style"
  add_index "vssc_ordered_contests", ["contest_identifier"], name: "vssc_ordered_contest_identifier"

  create_table "vssc_parties", force: :cascade do |t|
    t.integer  "election_report_id"
    t.integer  "name_id"
    t.string   "object_id"
    t.string   "abbreviation"
    t.string   "color"
    t.string   "logo_uri"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "contest_identifier"
  end

  add_index "vssc_parties", ["contest_identifier"], name: "vssc_party_contest"
  add_index "vssc_parties", ["election_report_id"], name: "vssc_party_election_report"
  add_index "vssc_parties", ["name_id"], name: "vssc_party_name"
  add_index "vssc_parties", ["object_id"], name: "vssc_party_object_id"

  create_table "vssc_party_party_id_refs", force: :cascade do |t|
    t.integer "party_id"
    t.string  "party_id_ref"
  end

  add_index "vssc_party_party_id_refs", ["party_id", "party_id_ref"], name: "vssc_party_party_id_ref"

  create_table "vssc_party_registrations", force: :cascade do |t|
    t.string   "type"
    t.integer  "election_report_id"
    t.string   "party_identifier"
    t.integer  "count"
    t.integer  "party_registrationable_id"
    t.string   "party_registrationable_type"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "vssc_party_registrations", ["election_report_id"], name: "vssc_party_registration_election_report"
  add_index "vssc_party_registrations", ["party_identifier"], name: "vssc_party_reg_identifier"
  add_index "vssc_party_registrations", ["party_registrationable_id", "party_registrationable_type"], name: "vssc_party_registrationable"

  create_table "vssc_people", force: :cascade do |t|
    t.integer  "election_report_id"
    t.string   "first_name"
    t.integer  "full_name_id"
    t.string   "last_name"
    t.text     "middle_names"
    t.string   "nickname"
    t.string   "party_identifier"
    t.string   "prefix"
    t.integer  "profession_id"
    t.string   "sufix"
    t.integer  "title_id"
    t.string   "object_id"
    t.date     "date_of_birth"
    t.string   "gender"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "vssc_people", ["election_report_id"], name: "vssc_person_election_report"
  add_index "vssc_people", ["full_name_id"], name: "vssc_person_full_name"
  add_index "vssc_people", ["object_id"], name: "vssc_person_object_id"
  add_index "vssc_people", ["profession_id"], name: "vssc_person_profession"
  add_index "vssc_people", ["title_id"], name: "vssc_perspon_title"

  create_table "vssc_schedules", force: :cascade do |t|
    t.integer  "schedulable_id"
    t.string   "schedulable_type"
    t.date     "end_date"
    t.date     "start_date"
    t.boolean  "is_only_by_appointment"
    t.boolean  "is_or_by_appointment"
    t.boolean  "is_subject_to_change"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "vssc_schedules", ["schedulable_id", "schedulable_type"], name: "vssc_schedulable"

  create_table "vssc_spatial_dimensions", force: :cascade do |t|
    t.integer  "spatial_extent_id"
    t.string   "map_uri"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "vssc_spatial_dimensions", ["spatial_extent_id"], name: "vssc_spatial_dimension_spatial_extent"

  create_table "vssc_spatial_extents", force: :cascade do |t|
    t.text     "coordinates"
    t.string   "format"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "vssc_terms", force: :cascade do |t|
    t.date     "end_date"
    t.date     "start_date"
    t.string   "office_term_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
