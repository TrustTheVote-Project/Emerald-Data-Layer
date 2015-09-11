# This migration comes from vssc_rails (originally 14)
class CreateVsscInternationalizedTexts < ActiveRecord::Migration
  def change
    create_table :vssc_internationalized_texts do |t|
      t.string :identifier
      
      t.timestamps null: false
    end
    
  end  
end
