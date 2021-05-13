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

  validates(*ATTRIBUTES, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 })
  ATTRIBUTES.each { |att| attribute att, :integer, default: 1 }
  validates(*ABILITIES, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 })
  ABILITIES.each { |ab| attribute ab, :integer, default: 0 }
  attribute :permanent_wp, :integer, default: 1
  validates :permanent_wp, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  attribute :remaining_wp, :integer, default: 1
  validates :remaining_wp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :permanent_wp }
  attribute :limit_break, :integer, default: 0
  validates :limit_break, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  attribute :permanent_ess, :integer, default: 1
  validates :permanent_ess, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  attribute :remaining_personal_ess, :integer, default: 0
  validates :remaining_personal_ess, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :personal_pool }
  attribute :remaining_periph_ess, :integer, default: 0
  validates :remaining_periph_ess, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :periph_pool }
  attribute :committed_ess, :integer, default: 0
  validates :committed_ess, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  attribute :unspent_xp, :integer, default: 0
  validates :unspent_xp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  attribute :total_xp, :integer, default: 0
  validates :total_xp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  attribute :unspent_spark_xp, :integer, default: 0
  validates :unspent_spark_xp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  attribute :total_spark_xp, :integer, default: 0
  validates :total_spark_xp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum spark: {
    dragon_blooded: 0,
    solar:          1
  }
  attribute :spark, :integer, default: 0

  belongs_to :user

  has_many :specialties, inverse_of: :character
  accepts_nested_attributes_for :specialties, reject_if: :all_blank, allow_destroy: true
  has_many :merits, inverse_of: :character
  accepts_nested_attributes_for :merits, reject_if: :all_blank, allow_destroy: true
  has_many :weapons, inverse_of: :character
  accepts_nested_attributes_for :weapons, reject_if: :all_blank, allow_destroy: true
  has_many :armours, inverse_of: :character
  accepts_nested_attributes_for :armours, reject_if: :all_blank, allow_destroy: true
  has_many :intimacies, inverse_of: :character
  accepts_nested_attributes_for :intimacies, reject_if: :all_blank, allow_destroy: true
  has_many :charms, -> { order 'ability' }, inverse_of: :character
  accepts_nested_attributes_for :charms, reject_if: :all_blank, allow_destroy: true
  has_many :health_levels, -> { order Arel.sql("
    CASE
      WHEN penalty == 'I' THEN -99
      WHEN penalty <> 'I' THEN cast(penalty as unsigned)
     END DESC") }, inverse_of: :character
  accepts_nested_attributes_for :health_levels, reject_if: :all_blank, allow_destroy: true

  before_save :reorder_damage

  def personal_pool
    case spark
    when 'dragon_blooded'
      11 + (permanent_ess || 2)
    when 'solar'
      10 + (permanent_ess || 1) * 3
    end
  end

  def periph_pool
    case spark
    when 'dragon_blooded'
      23 + (permanent_ess || 2) * 4
    when 'solar'
      26 + (permanent_ess || 1) * 7
    end
  end

  def soak
    stamina + armours.map(&:soak).sum
  end

  def hardness
    armours.map(&:hardness).max
  end

  # Static values - pool/2 round up
  def parry
    weapon = weapons.where(wielded: true).first
    ability = weapon&.ability || :brawl
    return 0 if %i[archery thrown].include? ability

    (dexterity + send(ability) + 1) / 2 + (weapon&.defence || 0)
  end
  def evasion
    (dexterity + dodge + 1) / 2
  end
  def guile
    (manipulation + socialise + 1) / 2
  end
  def resolve
    (wits + integrity + 1) / 2
  end

  # Pools
  def rush
    dexterity + athletics
  end
  def disengage
    dexterity + dodge
  end
  def join_battle
    wits + awareness
  end
  def wither(range: 'close')
    weapon = weapons.where(wielded: true).first
    weapon&.pool(range: range)
  end
  def decisive(range: 'close')
    weapon = weapons.where(wielded: true).first
    weapon&.pool(range: range)
  end
  def damage(range: 'close') # Base withering damage pool
    weapon = weapons.where(wielded: true).first
    weapon&.base_damage(range: range)
  end

  def hl_penalty
    worst_injury = health_levels.where.not(damaged: :ok).last
    if worst_injury
      worst_injury.penalty == 'I' ? :incap : worst_injury.penalty.to_i
    else
      0
    end
  end

  def injure(levels, damage_type)
    injuries = (health_levels.map(&:damaged) + [damage_type] * levels).tally
    order_injuries(injuries)
    save
  end

  private

  def reorder_damage
    injuries = health_levels.map(&:damaged).tally
    order_injuries(injuries)
  end

  def order_injuries(injuries)
    ordered = injuries.sort_by { |kind, _num| HealthLevel.damageds[kind] }.reverse
    expanded = ordered.map { |kind, num| [kind] * num }.flatten

    health_levels.zip(expanded).each { |hl, damage| hl.damaged = damage }
  end
end
