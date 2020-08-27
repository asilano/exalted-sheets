class Character < ApplicationRecord
  ATTRIBUTES = %i[
    strength
    dexterity
    stamina
    charisma
    manipulation
    appearance
    perception
    intelligence
    wits
  ].freeze
  ABILITIES = %i[
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
  ].freeze

  validates *ATTRIBUTES, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  ATTRIBUTES.each { |att| attribute att, :integer, default: 1 }
  validates *ABILITIES, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  ABILITIES.each { |ab| attribute ab, :integer, default: 0 }

  enum spark: {
    dragon_blooded: 0,
    solar:          1
  }

  has_many :specialties, inverse_of: :character
  accepts_nested_attributes_for :specialties, reject_if: :all_blank, allow_destroy: true
  has_many :merits, inverse_of: :character
  accepts_nested_attributes_for :merits, reject_if: :all_blank, allow_destroy: true
end
