class OrderService
  def self.create_order(order_params, customer_id:)
    customer = Customer.find_by(id: customer_id)
    return { error: "Customer not found" } if customer.nil?
  
    # Check if the order has no items
    return { error: "Order must contain items" } if order_params[:items].blank?
  
    order = Order.new(customer: customer)
  
    order_params[:items].each do |item|
      pizza = Pizza.find_by(id: item[:pizza_id])
      side = Side.find_by(id: item[:side_id])
  
      # Return error if neither pizza nor side is found
      return { error: "Invalid item selected" } if pizza.nil? && side.nil?
  
      extra_toppings = item[:extra_toppings] || []  # Ensure it's an array
      invalid_toppings = extra_toppings.any? { |topping_id| Topping.find_by(id: topping_id).nil? }
      return { error: "Invalid item selected" } if invalid_toppings
  
      # 🚨 **Check that only one crust is selected**
      if item[:crust].is_a?(Array) && item[:crust].length > 1
        return { error: "Only one type of crust can be selected for a pizza" }
      end
  
      if item[:size] != "Large"
        # Vegetarian pizza cannot have non-veg toppings
        if pizza&.category == "vegetarian" && extra_toppings.any? { |topping_id| Topping.find(topping_id).category == "non_vegetarian" }
          return { error: "Vegetarian pizza cannot have a non-vegetarian topping" }
        end
  
        # Non-vegetarian pizza cannot have paneer topping
        if pizza&.category == "non_vegetarian" && extra_toppings.include?(Topping.find_by(name: "Paneer")&.id)
          return { error: "Non-vegetarian pizza cannot have paneer topping" }
        end
  
        # Non-vegetarian pizza cannot have multiple non-veg toppings
        if pizza&.category == "non_vegetarian"
          non_veg_toppings = extra_toppings.map { |topping_id| Topping.find(topping_id) }.select { |topping| topping&.category == "non_vegetarian" }
          return { error: "You can add only one of the non-veg toppings in non-vegetarian pizza" } if non_veg_toppings.length > 1
        end
      end
  
      # Calculate price for pizza
      price = calculate_price(pizza, item)
      order.order_items.build(pizza: pizza, side: side, size: item[:size], crust: item[:crust], price: price)
    end
  
    Rails.logger.debug("Order items: #{order.order_items.inspect}")
  
    # Check inventory only after all validations pass
    return { error: "Inventory shortage or invalid order" } unless validate_inventory(order)
  
    # Save the order and update inventory
    if order.save
      update_inventory(order)
      { success: "Order placed successfully", order: order }
    else
      { error: "Order could not be saved" }
    end
  end
  

  def self.calculate_price(pizza, item)
    base_price = 0.0

    # Assign base price based on the pizza size
    case item[:size]
    when "Regular"
      base_price = pizza.regular_price
    when "Medium"
      base_price = pizza.medium_price
    when "Large"
      base_price = pizza.large_price
    else
      base_price = 0.0
      Rails.logger.debug("Unexpected size: #{item[:size]}")
    end

    base_price = base_price.to_f

    # Add extra toppings price if not a large pizza
    unless item[:size] == "Large"
      base_price += (item[:extra_toppings] || []).sum { |topping_id| Topping.find(topping_id).price }
    end

    base_price
  end  

  def self.validate_inventory(order)
    order.order_items.none? do |item|
      inventory = nil
      next false if item.size == "Large" 
      if item.pizza
        inventory = Inventory.find_by(item_name: item.pizza.name)
      elsif item.side
        inventory = Inventory.find_by(item_name: item.side.name)
      end

      inventory.nil? || inventory.quantity.to_i <= 0
    end
  end 

  def self.update_inventory(order)
    order.order_items.each do |item|
      inventory = Inventory.find_by(item_name: item.pizza&.name || item.side&.name)
      inventory.update(quantity: inventory.quantity - 1) if inventory
    end
  end
end
