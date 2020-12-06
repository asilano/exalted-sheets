class Charm < ApplicationRecord
  belongs_to :character

  serialize :keywords, Array

  enum variety: { simple:       0,
                  reflexive:    1,
                  supplemental: 2,
                  permanent:    3 }

  def keywords_string
    keywords.join(', ')
  end

  def keywords_string=(val)
    self.keywords = val.gsub(/ /, '').split(',')
  end
end
