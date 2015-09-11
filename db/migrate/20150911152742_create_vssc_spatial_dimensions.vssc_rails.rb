# This migration comes from vssc_rails (originally 23)
class CreateVsscSpatialDimensions < ActiveRecord::Migration
  def change
    create_table :vssc_spatial_dimensions do |t|
      t.integer :spatial_extent_id
      t.string :map_uri
      
      t.timestamps null: false
    end
    add_index :vssc_spatial_dimensions, :spatial_extent_id, name: :vssc_spatial_dimension_spatial_extent
  end  
end
