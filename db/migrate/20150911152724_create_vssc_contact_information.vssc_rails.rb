# This migration comes from vssc_rails (originally 5)
class CreateVsscContactInformation < ActiveRecord::Migration
  def change
    create_table :vssc_contact_information do |t|
      t.integer :contactable_id
      t.string :contactable_type

      t.text :address_line
      t.text :email
      t.text :fax
      t.string :name
      t.text :phone

      t.text :uri
      t.timestamps null: false
    end
    add_index :vssc_contact_information, [:contactable_id, :contactable_type], name: :vssc_contactable

  end  
end
