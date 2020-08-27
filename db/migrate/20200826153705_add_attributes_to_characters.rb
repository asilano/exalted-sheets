class AddAttributesToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :strength, :integer
    add_column :characters, :dexterity, :integer
    add_column :characters, :stamina, :integer
    add_column :characters, :charisma, :integer
    add_column :characters, :manipulation, :integer
    add_column :characters, :appearance, :integer
    add_column :characters, :perception, :integer
    add_column :characters, :intelligence, :integer
    add_column :characters, :wits, :integer
  end
end
