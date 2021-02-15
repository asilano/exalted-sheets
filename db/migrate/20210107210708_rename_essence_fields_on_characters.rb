class RenameEssenceFieldsOnCharacters < ActiveRecord::Migration[6.0]
  def change
    rename_column :characters, :remain_personal_ess, :remaining_personal_ess
    rename_column :characters, :remain_periph_ess, :remaining_periph_ess
  end
end
