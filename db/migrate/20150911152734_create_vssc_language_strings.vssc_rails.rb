# This migration comes from vssc_rails (originally 15)
# define_attribute("Language") #type: "xsd:language"
class CreateVsscLanguageStrings < ActiveRecord::Migration
  def change
    create_table :vssc_language_strings do |t|
      t.integer :internationalized_text_id
      t.string :language
      t.text :text
      
      t.timestamps null: false
    end
    add_index :vssc_language_strings, :internationalized_text_id, name: :vssc_language_string_internationalized_text
  end  
end
