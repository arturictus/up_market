class CreateOrder < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :business_entity, null: false, foreign_key: true
      t.integer :shares
      t.integer :price_per_share
      t.boolean :executed, default: false

      t.timestamps
    end
  end
end
