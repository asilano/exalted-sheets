class ChangeHealthLevelsPenaltyToString < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up   { change_column :health_levels, :penalty, :string }
      dir.down { change_column :health_levels, :penalty, :integer }
    end
  end
end
