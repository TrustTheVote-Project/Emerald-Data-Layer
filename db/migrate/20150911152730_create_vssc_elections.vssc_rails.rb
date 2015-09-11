# This migration comes from vssc_rails (originally 11)
class CreateVsscElections < ActiveRecord::Migration
  def change
    create_table :vssc_elections do |t|
      t.integer :contact_information_id
      
      t.string :election_scope_identifier
      
      t.integer :name_id
      
      t.date :date
      t.date :end_date
      t.string :election_type
      
      t.timestamps null: false
    end
    add_index :vssc_elections, :contact_information_id, name: :vssc_election_contact_information
    add_index :vssc_elections, :election_scope_identifier, name: :vssc_elections_gp_scope
    add_index :vssc_elections, :name_id, name: :vssc_elections_name
    
  end  
end
