# This migration comes from vssc_rails (originally 2)
class CreateVsscBallotStyles < ActiveRecord::Migration
  def change
    create_table :vssc_ballot_styles do |t|
      t.integer :election_id
      t.string :image_uri
      t.string :ballot_style_identifier
      
      t.timestamps null: false
    end
    add_index :vssc_ballot_styles, :election_id, name: :vssc_ballot_style_election
    
    create_table :vssc_ballot_style_gp_unit_id_refs do |t|
      t.integer :ballot_style_id
      t.string :gp_unit_id_ref
    end
    add_index :vssc_ballot_style_gp_unit_id_refs, [:gp_unit_id_ref, :ballot_style_id], name: :vssc_ballot_style_gp_units
    
    create_table :vssc_ballot_style_party_id_refs do |t|
      t.integer :ballot_style_id
      t.string :party_id_ref
    end
    add_index :vssc_ballot_style_party_id_refs, [:party_id_ref, :ballot_style_id], name: :vssc_ballot_style_parties
    
  end  
end
