class BusinessOwner < ApplicationRecord
  has_many :business_entities
  has_many :orders, through: :business_entities
  has_many :buyers, through: :orders

  validates_presence_of :name
end
