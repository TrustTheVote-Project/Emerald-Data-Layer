# This migration comes from vssc_rails (originally 3)
class CreateVsscCandidates < ActiveRecord::Migration
  def change
    create_table :vssc_candidates do |t|
      t.integer :election_id
      t.integer :ballot_name_id
      
      t.string :party_identifier
      t.string :person_identifier
      
      t.string :object_id
      t.date :file_date
      t.string :candidate_identifier
      t.boolean :is_incumbent
      t.boolean :is_top_ticket
      t.string :post_election_status
      t.string :pre_election_status
      t.integer :sequence_order
      
      t.timestamps null: false
    end
    add_index :vssc_candidates, :election_id, name: :vssc_candidate_election
    add_index :vssc_candidates, :ballot_name_id, name: :vssc_candidate_ballot_name
    add_index :vssc_candidates, :object_id, name: :vssc_candidate_object_id
    
  end  
end
