# This migration comes from vssc_rails (originally 17)
class CreateVsscOffices < ActiveRecord::Migration
  def change
    create_table :vssc_offices do |t|
      t.integer :office_group_id
      t.integer :election_report_id
      
      t.integer :contact_information_id
      
      t.string :jurisdictional_scope_identifier
      t.integer :name_id
      
      t.integer :term_id
      
      t.string :object_id
      t.datetime :filing_deadline
      t.boolean :is_partisan
      
      t.timestamps null: false
    end
    add_index :vssc_offices, :election_report_id, name: :vssc_office_election_report
    add_index :vssc_offices, :office_group_id, name: :vssc_office_office_group
    add_index :vssc_offices, :contact_information_id, name: :vssc_office_contact_information
    add_index :vssc_offices, :jurisdictional_scope_identifier, name: :vssc_office_jurisdiction_scope
    add_index :vssc_offices, :name_id, name: :vssc_office_name
    add_index :vssc_offices, :term_id, name: :vssc_office_term
    add_index :vssc_offices, :object_id, name: :vssc_office_object_id
    
    
    create_table :vssc_office_office_holder_id_refs do |t|
      t.integer :office_id
      t.string :office_holder_id_ref
    end
    add_index :vssc_office_office_holder_id_refs, [:office_id, :office_holder_id_ref], name: :vssc_office_office_holder_ref
    
  end  
end
