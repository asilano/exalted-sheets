class AddWillpowerLimitToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :permanent_wp, :integer
    add_column :characters, :remaining_wp, :integer
    add_column :characters, :limit_break, :integer
  end
end
