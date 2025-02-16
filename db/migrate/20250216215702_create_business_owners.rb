class CreateBusinessOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :business_owners do |t|
      t.string :name

      t.timestamps
    end

    add_reference :business_entities, :business_owner
  end
end
