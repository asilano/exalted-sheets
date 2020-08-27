class AddAbilitiesToCharacters < ActiveRecord::Migration[6.0]
  def change
    %i[
      archery
      athletics
      awareness
      brawl
      bureaucracy
      craft
      dodge
      integrity
      investigation
      larceny
      linguistics
      lore
      martial_arts
      medicine
      melee
      occult
      performance
      presence
      resistance
      ride
      sail
      socialise
      stealth
      survival
      thrown
      war
    ].each do |abil|
      add_column :characters, abil, :integer
      add_column :characters, "favoured_#{abil}", :boolean
    end
  end
end
