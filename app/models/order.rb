class Order < ApplicationRecord
  belongs_to :buyer
  belongs_to :business_entity
  validates_presence_of :shares, :price_per_share
  validates_inclusion_of :executed, in: [ true, false ]
  validates_numericality_of :shares, greater_than: 0
  validates_numericality_of :price_per_share, greater_than: 0

  def execute
    execute!
    true
  rescue
    errors.add(:base, "Order could not be executed")
    false
  end

  def execute!
    transaction do
      business_entity.with_lock do
        if business_entity.remaining_supply >= shares
          business_entity.sold_supply += shares
          business_entity.save!
          self.executed = true
          save!
        else
          raise "Not enough shares available"
        end
      end
    end
  end

  def self.create_order!(buyer:, business_entity:, shares:, price_per_share:)
    transaction do
      if business_entity.remaining_supply > shares
        create!(buyer: buyer, business_entity: business_entity, shares: shares, price_per_share: price_per_share, executed: false)
      else
        raise "Not enough shares available"
      end
    end
  end

  def self.create_and_execute!(buyer:, business_entity:, shares:, price_per_share:)
    transaction do
      business_entity.with_lock do
        if business_entity.remaining_supply > shares
          business_entity.sold_supply += shares
          business_entity.save!
          create!(buyer: buyer, business_entity: business_entity, shares: shares, price_per_share: price_per_share, executed: true)
        else
          raise "Not enough shares available"
        end
      end
    end
  end
end
