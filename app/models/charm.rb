class Charm < ApplicationRecord
  belongs_to :character

  serialize :keywords, Array

  def keywords_string
    keywords.join(', ')
  end

  def keywords_string=(val)
    self.keywords = val.gsub(/ /, '').split(',')
  end
end
