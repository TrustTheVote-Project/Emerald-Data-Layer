# This migration comes from vssc_rails (originally 9)
class CreateVsscDevices < ActiveRecord::Migration
  def change
    create_table :vssc_devices do |t|
      t.string :manufacturer
      t.string :model
      t.string :device_type
      
      t.timestamps null: false
    end
    
  end  
end
