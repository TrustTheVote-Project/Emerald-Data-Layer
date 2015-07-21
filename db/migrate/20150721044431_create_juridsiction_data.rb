class CreateJuridsictionData < ActiveRecord::Migration
  def change
    create_table :juridsiction_data do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
