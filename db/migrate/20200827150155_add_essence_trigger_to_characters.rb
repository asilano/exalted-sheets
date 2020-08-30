class AddEssenceTriggerToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :permanent_ess, :integer
    add_column :characters, :remain_personal_ess, :integer
    add_column :characters, :remain_periph_ess, :integer
    add_column :characters, :committed_ess, :integer
    add_column :characters, :limit_trigger, :string
  end
end
