class CreateBeers < ActiveRecord::Migration[8.0]
  def change
    create_table :beers do |t|
      t.string :name
      t.decimal :abv

      t.timestamps
    end
  end
end
