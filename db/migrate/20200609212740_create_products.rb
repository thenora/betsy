class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :description
      t.integer :inventory

      t.timestamps
    end
  end
end
