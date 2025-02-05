class OrderService
  def self.create_order(order_params, customer_id:)
    customer = Customer.find_by(id: customer_id)
    return { error: "Customer not found" } if customer.nil?

    order = Order.new(customer: customer)
    
    order_params[:items].each do |item|
      pizza = Pizza.find_by(id: item[:pizza_id])
      side = Side.find_by(id: item[:side_id])

      return { error: "Invalid item selected" } if pizza.nil? && side.nil?

      price = calculate_price(pizza, item)
      order.order_items.build(pizza: pizza, side: side, size: item[:size], crust: item[:crust], price: price)
    end

    if validate_inventory(order) && order.save
      update_inventory(order)
      { success: "Order placed successfully", order: order }
    else
      { error: "Inventory shortage or invalid order" }
    end
  end

  def self.calculate_price(pizza, item)
    base_price = case item[:size]
                  when "Regular" then pizza.regular_price
                  when "Medium" then pizza.medium_price
                  when "Large" then pizza.large_price
                  end
    base_price += item[:extra_toppings].sum { |topping_id| Topping.find(topping_id).price } unless item[:size] == "Large"
    base_price
  end

  def self.validate_inventory(order)
    order.order_items.all? { |item| Inventory.find_by(item_name: item.pizza&.name || item.side&.name)&.quantity.to_i > 0 }
  end

  def self.update_inventory(order)
    order.order_items.each do |item|
      inventory = Inventory.find_by(item_name: item.pizza&.name || item.side&.name)
      inventory.update(quantity: inventory.quantity - 1) if inventory
    end
  end
end
