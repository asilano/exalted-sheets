class Armour < ApplicationRecord
  belongs_to :character

  serialize :tags, Array

  def tags_string
    tags.join(', ')
  end

  def tags_string=(val)
    self.tags = val.gsub(/ /, '').split(',')
  end

end
