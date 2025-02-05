class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.references :pizza, foreign_key: true, optional: true
      t.references :side, foreign_key: true, optional: true
      t.string :size # Regular, Medium, Large
      t.string :crust
      t.decimal :price

      t.timestamps
    end
  end
end
