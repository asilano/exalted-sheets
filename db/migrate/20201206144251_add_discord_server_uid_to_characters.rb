class AddDiscordServerUidToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :discord_server_uid, :integer
  end
end
