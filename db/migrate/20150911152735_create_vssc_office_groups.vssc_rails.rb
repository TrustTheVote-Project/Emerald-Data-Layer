# This migration comes from vssc_rails (originally 16)
class CreateVsscOfficeGroups < ActiveRecord::Migration
  def change
    create_table :vssc_office_groups do |t|
      t.integer :office_groupable_id
      t.string :office_groupable_type
      
      t.string :name
      
      t.timestamps null: false
    end
    add_index :vssc_office_groups, [:office_groupable_id, :office_groupable_type], name: :vssc_office_groupable
    
    create_table :vssc_office_group_office_ids do |t|
      t.integer :office_id
      t.string :office_id_ref
    end
    add_index :vssc_office_group_office_ids, [:office_id, :office_id_ref], name: :vssc_office_group_office_refs
    
  end  
end
