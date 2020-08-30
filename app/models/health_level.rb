class HealthLevel < ApplicationRecord
  belongs_to :character

  before_validation :destroy_on_blank

  private

  def destroy_on_blank
    mark_for_destruction if penalty.blank?
  end
end
