class Order < ApplicationRecord
  belongs_to :buyer
  belongs_to :business_entity
  validates_presence_of :shares, :price_per_share, :executed

  def execute
    transaction do
      business_entity.with_lock do
        if business_entity.remaining_supply >= shares
          business_entity.sold_supply += shares
          business_entity.save!
          self.executed = true
          save!
        end
      end
    end
  end

  def self.create_order!(buyer:, business_entity:, shares:, price_per_share:)
    transaction do
      business_entity.with_lock do
        if business_entity.remaining_supply < shares
          create!(buyer: buyer, business_entity: business_entity, shares: shares, price_per_share: price_per_share, executed: false)
        end
      end
    end
  end

  def self.create_and_execute!(buyer:, business_entity:, shares:, price_per_share:)
    transaction do
      business_entity.with_lock do
        business_entity.sold_supply += shares
        business_entity.save!
        create!(buyer: buyer, business_entity: business_entity, shares: shares, price_per_share: price_per_share)
      end
    end
  end
end
