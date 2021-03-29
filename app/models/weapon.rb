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

  THROWN_ACCURACY = {
    'close'   =>  4,
    'short'   =>  3,
    'medium'  =>  2,
    'long'    => -1,
    'extreme' => -3
  }.freeze
  ARCHERY_ACCURACY = {
    'close'   => -2,
    'short'   =>  4,
    'medium'  =>  2,
    'long'    =>  0,
    'extreme' => -2
  }.freeze
  def pool(range: 'close')
    return 0 unless (abil = ability)

    accur = case abil
            when :thrown
              THROWN_ACCURACY[range] + accuracy
            when :archery
              ARCHERY_ACCURACY[range] + accuracy
            else
              accuracy
            end

    character.dexterity + character.send(abil) + accur
  end
end
