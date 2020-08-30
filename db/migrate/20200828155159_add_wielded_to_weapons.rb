class AddWieldedToWeapons < ActiveRecord::Migration[6.0]
  def change
    add_column :weapons, :wielded, :boolean
  end
end
