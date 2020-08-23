class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.string :discord_user
      t.string :name
      t.integer :strength
      t.integer :athletics

      t.timestamps
    end
  end
end
