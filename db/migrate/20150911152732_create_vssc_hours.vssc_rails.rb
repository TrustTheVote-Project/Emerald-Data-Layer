# This migration comes from vssc_rails (originally 13)
class CreateVsscHours < ActiveRecord::Migration
  def change
    create_table :vssc_hours do |t|
      
      t.integer :hourable_id
      t.string :hourable_type
      
      t.string :day
      t.datetime :end_time
      t.datetime :start_time
      
      t.timestamps null: false
    end
    add_index :vssc_hours, [:hourable_id, :hourable_type], name: :vssc_hourable
  end  
end
