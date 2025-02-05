class CreateToppings < ActiveRecord::Migration[6.1]
  def change
    create_table :toppings do |t|
      t.string :name
      t.string :category # Veg or Non-Veg
      t.decimal :price

      t.timestamps
    end
  end
end
