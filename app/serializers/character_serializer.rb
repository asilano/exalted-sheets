class CharacterSerializer < AllSerializer
  has_many :health_levels
  attributes :soak, :hardness
end
