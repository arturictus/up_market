class CreateBuyer < ActiveRecord::Migration[8.0]
  def change
    create_table :buyers do |t|
      t.string :name
      t.references :basic_auth, null: false, foreign_key: true

      t.timestamps
    end
  end
end
