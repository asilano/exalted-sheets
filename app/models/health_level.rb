class HealthLevel < ApplicationRecord
  belongs_to :character

  before_validation :destroy_on_blank

  enum damaged: {
    ok:         0,
    bashing:    1,
    lethal:     2,
    aggravated: 3
  }
  attribute :damaged, :integer, default: 0

  private

  def destroy_on_blank
    mark_for_destruction if penalty.blank?
  end
end
