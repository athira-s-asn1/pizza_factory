# PizzaFactory - Pizza Ordering System

## Overview
**PizzaFactory** is a Ruby on Rails application that allows customers to place pizza orders while ensuring various business rules are followed. The system handles orders, inventory, and pricing dynamically. 

Whether you're craving a vegetarian delight or a meaty feast, PizzaFactory makes ordering pizzas simple and fun.

## Features
- **Pizza Customization:** Customers can order pizzas with different sizes, crust types, and toppings.
- **Business Rules:**
  - Vegetarian pizzas cannot have non-vegetarian toppings.
  - Non-vegetarian pizzas cannot have a paneer topping.
  - Only one type of crust per pizza.
  - Non-vegetarian pizzas allow only one non-vegetarian topping.
  - Large pizzas include up to **two free toppings**.
- **Inventory Management:** Orders update inventory dynamically to reflect changes.
- **Pricing:** Pricing is handled dynamically based on pizza size, crust type, and toppings.

## Technologies Used
- **Ruby on Rails**
- **RSpec** (for testing)
- **FactoryBot** (for test data setup)
- **ActiveRecord** (ORM)
- **SQLite/PostgreSQL** (database)

## Installation

### Clone the Repository
```bash
git clone https://github.com/your-username/pizza-factory.git
cd pizza-factory

Install Dependencies
```bash
bundle install
Set up the Database
```bash
rails db:create db:migrate db:seed
Start the Server
```bash

rails server
Running Tests
Run the RSpec test suite to ensure everything works correctly:

```bash

bundle exec rspec
API Endpoints
Create Order (POST /orders)
Place a new order with specific items like pizza, sides, size, crust, and toppings.

Request Body:
json
{
  "customer_id": 1,
  "order": {
    "items": [
      {
        "pizza_id": 2,
        "side_id": 5,
        "size": "Medium",
        "crust": "Thin",
        "extra_toppings": [3, 4]
      }
    ]
  }
}
Response:
json
{
  "order": {
    "id": 7,
    "customer_name": "John Doe",
    "items": [
      {
        "pizza_name": "Margherita",
        "side_name": "Garlic Bread",
        "size": "Medium",
        "crust": "Thin",
        "price": "250.0"
      }
    ],
    "total_price": "250.0"
  },
  "message": "Order placed successfully"
}
