class AddDamagedToHealthLevels < ActiveRecord::Migration[6.0]
  def change
    add_column :health_levels, :damaged, :integer, default: 0
  end
end
