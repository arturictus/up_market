class CreateBusinessEntity < ActiveRecord::Migration[8.0]
  def change
    create_table :business_entities do |t|
      t.string :name, null: false
      t.integer :share_supply, null: false
      t.integer :sold_supply, null: false, default: 0

      t.index :name, unique: true
      t.timestamps
    end
  end
end
