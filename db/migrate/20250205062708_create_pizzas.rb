class CreatePizzas < ActiveRecord::Migration[6.1]
  def change
    create_table :pizzas do |t|
      t.string :name
      t.string :category # Veg or Non-Veg
      t.decimal :regular_price
      t.decimal :medium_price
      t.decimal :large_price

      t.timestamps
    end
  end
end
