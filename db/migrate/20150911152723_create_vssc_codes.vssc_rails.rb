# This migration comes from vssc_rails (originally 4)
class CreateVsscCodes < ActiveRecord::Migration
  def change
    create_table :vssc_codes do |t|
      t.string :codeable_type
      t.integer :codeable_id
      
      t.string :other_type
      t.string :code_type
      t.string :value
      
      t.timestamps null: false
    end
    add_index :vssc_codes, [:codeable_type, :codeable_id], name: :vssc_codeable
  end  
end
