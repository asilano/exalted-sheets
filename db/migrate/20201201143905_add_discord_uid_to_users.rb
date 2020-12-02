class AddDiscordUidToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discord_uid, :integer
  end
end
