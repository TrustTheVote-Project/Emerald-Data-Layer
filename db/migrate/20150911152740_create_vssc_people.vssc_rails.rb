# This migration comes from vssc_rails (originally 21)
class CreateVsscPeople < ActiveRecord::Migration
  def change
    create_table :vssc_people do |t|
      t.integer :election_report_id
      t.string :first_name
      t.integer :full_name_id
      t.string :last_name
      t.text :middle_names
      t.string :nickname
      t.string :party_identifier
      t.string :prefix
      t.integer :profession_id
      t.string :sufix
      t.integer :title_id
      
      t.string :object_id
      t.date :date_of_birth
      t.string :gender
      
      t.timestamps null: false
    end
    add_index :vssc_people, :election_report_id, name: :vssc_person_election_report
    add_index :vssc_people, :full_name_id, name: :vssc_person_full_name
    add_index :vssc_people, :profession_id, name: :vssc_person_profession
    add_index :vssc_people, :title_id, name: :vssc_perspon_title
    add_index :vssc_people, :object_id, name: :vssc_person_object_id
    
  end  
end
