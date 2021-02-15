class AddAnimaLevelToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :anima_level, :integer
  end
end
