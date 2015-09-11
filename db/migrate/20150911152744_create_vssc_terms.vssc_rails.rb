# This migration comes from vssc_rails (originally 25)
class CreateVsscTerms < ActiveRecord::Migration
  def change
    create_table :vssc_terms do |t|
      t.date :end_date
      t.date :start_date
      t.string :office_term_type
      
      t.timestamps null: false
    end
  end  
end
