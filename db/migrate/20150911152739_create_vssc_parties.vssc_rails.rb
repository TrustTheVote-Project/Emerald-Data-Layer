# This migration comes from vssc_rails (originally 20)
class CreateVsscParties < ActiveRecord::Migration
  def change
    create_table :vssc_parties do |t|
      t.integer :election_report_id
      t.integer :name_id

      t.string :object_id
      t.string :abbreviation
      t.string :color
      t.string :logo_uri
      
      t.timestamps null: false

      #coalition
      t.string :contest_identifier
  
    end
    add_index :vssc_parties, :election_report_id, name: :vssc_party_election_report
    add_index :vssc_parties, :name_id, name: :vssc_party_name
    add_index :vssc_parties, :object_id, name: :vssc_party_object_id
    add_index :vssc_parties, :contest_identifier, name: :vssc_party_contest
    
    #coaltion
    create_table :vssc_party_party_id_refs do |t|
      t.integer :party_id
      t.string :party_id_ref
    end
    add_index :vssc_party_party_id_refs, [:party_id, :party_id_ref], name: :vssc_party_party_id_ref
    

  end  
end
