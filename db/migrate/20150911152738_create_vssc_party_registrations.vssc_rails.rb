# This migration comes from vssc_rails (originally 19)
class CreateVsscPartyRegistrations < ActiveRecord::Migration
  def change
    create_table :vssc_party_registrations do |t|
      t.string :type
      t.integer :election_report_id
      t.string :party_identifier
      t.integer :count
      
      t.integer :party_registrationable_id
      t.string  :party_registrationable_type
      
      t.timestamps null: false
      
    end    
    add_index :vssc_party_registrations, :election_report_id, name: :vssc_party_registration_election_report
    add_index :vssc_party_registrations, :party_identifier, name: :vssc_party_reg_identifier
    add_index :vssc_party_registrations, [:party_registrationable_id, :party_registrationable_type], name: :vssc_party_registrationable
    
  end  
end
