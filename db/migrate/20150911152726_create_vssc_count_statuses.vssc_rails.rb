# This migration comes from vssc_rails (originally 7)
class CreateVsscCountStatuses < ActiveRecord::Migration
  def change
    create_table :vssc_count_statuses do |t|
      t.integer :count_statusable_id
      t.string :count_statusable_type
      
      t.string :other_type
      t.string :status
      t.string :count_item_type
      
      t.timestamps null: false
    end
    add_index :vssc_count_statuses, [:count_statusable_id, :count_statusable_type], name: :vssc_count_statusable

  end  
end
