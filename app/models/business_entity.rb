class BusinessEntity < ApplicationRecord
  validates_presence_of :name, :share_supply, :sold_supply, :business_owner
  validates_uniqueness_of :name
  validates_numericality_of :share_supply, greater_than_or_equal_to: 1
  validates_numericality_of :sold_supply, greater_than_or_equal_to: 0
  validate :sold_supply_cannot_exceed_share_supply

  belongs_to :business_owner
  has_many :orders

  def remaining_supply
    share_supply - sold_supply
  end

  private

  def sold_supply_cannot_exceed_share_supply
    if sold_supply.present? && share_supply.present? && sold_supply > share_supply
      errors.add(:sold_supply, "cannot be greater than share supply")
    end
  end
end
