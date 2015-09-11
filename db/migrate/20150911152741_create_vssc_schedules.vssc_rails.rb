# This migration comes from vssc_rails (originally 22)
class CreateVsscSchedules < ActiveRecord::Migration
  def change
    create_table :vssc_schedules do |t|
      t.integer :schedulable_id
      t.string :schedulable_type
      
      t.date :end_date
      t.date :start_date
      t.boolean :is_only_by_appointment
      t.boolean :is_or_by_appointment
      t.boolean :is_subject_to_change
      
      t.timestamps null: false
    end
    add_index :vssc_schedules, [:schedulable_id, :schedulable_type], name: :vssc_schedulable
  end  
end
