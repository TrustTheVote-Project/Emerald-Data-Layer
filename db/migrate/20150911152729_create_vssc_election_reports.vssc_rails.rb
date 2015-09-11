# This migration comes from vssc_rails (originally 10)
class CreateVsscElectionReports < ActiveRecord::Migration
  def change
    create_table :vssc_election_reports do |t|
      t.string :message
      t.integer :election_id
      
      t.text :notes
      
      t.string :format
      t.datetime :generated_date
      t.string :issuer
      t.string :issuer_abbreviation
      t.boolean :is_test
      t.integer :sequence
      t.integer :sequence_end
      t.string :status
      t.string :test_type
      t.string :vendor_application_identifier
      
      t.timestamps null: false
    end
    add_index :vssc_election_reports, :election_id, name: :vssc_election_reports_election

  end  
end
