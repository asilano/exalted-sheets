class Weapon < ApplicationRecord
  belongs_to :character

  serialize :tags, Array

  def tags_string
    tags.join(', ')
  end

  def tags_string=(val)
    self.tags = val.gsub(/ /, '').split(',')
  end

  def ability
    (tags.map(&:downcase).map(&:underscore).map(&:to_sym) & Character::ABILITIES).first
  end

  def pool
    return 0 unless (abil = ability)

    character.dexterity + character.send(abil) + accuracy
  end
end
