class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
