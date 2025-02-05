# Create customers
customers = Customer.create([
    { name: "John Doe", email: "john@example.com", phone: "1234567890" },
    { name: "Jane Doe", email: "jane@example.com", phone: "0987654321" }
  ])
  
  # Create pizzas
  pizzas = Pizza.create([
    { name: "Margherita", category: "Vegetarian", regular_price: 200, medium_price: 250, large_price: 300 },
    { name: "Pepperoni", category: "Non-Vegetarian", regular_price: 250, medium_price: 300, large_price: 350 }
  ])
  
  # Create sides
  sides = Side.create([
    { name: "Garlic Bread", price: 50 },
    { name: "Cheesy Sticks", price: 70 }
  ])
  
  # Create toppings
  toppings = Topping.create([
    { name: "Mushrooms", price: 30 },
    { name: "Olives", price: 40 }
  ])
  
  # Create inventory for each item
  Inventory.create([
    { item_name: "Margherita", quantity: 100 },
    { item_name: "Pepperoni", quantity: 100 },
    { item_name: "Garlic Bread", quantity: 100 },
    { item_name: "Cheesy Sticks", quantity: 100 }
  ])
  
  # Create some orders
  Order.create([
    {
      customer_id: customers.first.id,
      status: 'pending',  # Assuming you have a 'status' field
      created_at: Time.now,
      updated_at: Time.now,
      order_items: [
        OrderItem.new(pizza: pizzas.first, size: "Medium", crust: "Thin", price: 250),
        OrderItem.new(side: sides.first, price: 50)
      ]
    },
    {
      customer_id: customers.last.id,
      status: 'pending',
      created_at: Time.now,
      updated_at: Time.now,
      order_items: [
        OrderItem.new(pizza: pizzas.last, size: "Large", crust: "Cheese Burst", price: 350),
        OrderItem.new(side: sides.last, price: 70)
      ]
    }
  ])
  
  puts "Seed data created successfully!"
  