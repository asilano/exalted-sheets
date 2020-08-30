class Intimacy < ApplicationRecord
  belongs_to :character

  enum variety: { tie: 0, principle: 1 }
  enum intensity: { minor: 2, major: 3, defining: 4 }
end
