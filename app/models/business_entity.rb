class BusinessEntity < ApplicationRecord
  validates :name, presence: true
  validates :share_supply, presence: true
  validates :sold_supply, presence: true
  validates_uniqueness_of :name
end
