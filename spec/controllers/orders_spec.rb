require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:customer) { create(:customer) }
  let(:vegetarian_pizza) { create(:pizza, category: "vegetarian", regular_price: 150, medium_price: 200, large_price: 325) }
  let(:non_vegetarian_pizza) { create(:pizza, category: "non_vegetarian", regular_price: 190, medium_price: 250, large_price: 375) }
  let(:side) { create(:side, price: 50) }
  let(:paneer_topping) { create(:topping, name: "Paneer", price: 35) }
  let(:chicken_tikka_topping) { create(:topping, name: "Chicken Tikka", price: 40, category: "non_vegetarian") }
  
  let(:inventory) { instance_double("Inventory", quantity: 10) }

  before do
    allow(Inventory).to receive(:find_by).and_return(inventory)
    allow(inventory).to receive(:update).and_return(true)
  end

  describe 'POST #create' do
    context 'when no items are provided' do
      it 'returns an error for missing items' do
        order_params = { items: [] }
  
        result = OrderService.create_order(order_params, customer_id: customer.id)
  
        expect(result[:error]).to eq("Order must contain items")
      end
    end

    context 'when an invalid topping is provided' do
      it 'returns an error when the topping is invalid' do
        order_params = {
          items: [
            { pizza_id: vegetarian_pizza.id, size: "Medium", crust: "Thin", extra_toppings: [9999] }
          ]
        }
    
        result = OrderService.create_order(order_params, customer_id: customer.id)
    
        expect(result[:error]).to eq("Invalid item selected")
      end
    end

    context 'when placing an order with a vegetarian pizza' do
      it 'does not allow non-veg toppings' do
        order_params = {
          items: [
            { pizza_id: vegetarian_pizza.id, size: "Medium", crust: "Thin", extra_toppings: [chicken_tikka_topping.id] }
          ]
        }

        result = OrderService.create_order(order_params, customer_id: customer.id)

        expect(result[:error]).to eq("Vegetarian pizza cannot have a non-vegetarian topping")
      end
    end

    context 'when placing an order with a non-vegetarian pizza' do
      it 'does not allow paneer topping' do
        order_params = {
          items: [
            { pizza_id: non_vegetarian_pizza.id, size: "Medium", crust: "Thin", extra_toppings: [paneer_topping.id] }
          ]
        }

        result = OrderService.create_order(order_params, customer_id: customer.id)

        expect(result[:error]).to eq("Non-vegetarian pizza cannot have paneer topping")
      end

      it 'allows only one non-veg topping' do
        order_params = {
          items: [
            { pizza_id: non_vegetarian_pizza.id, size: "Medium", crust: "Thin", extra_toppings: [chicken_tikka_topping.id, chicken_tikka_topping.id] }
          ]
        }

        result = OrderService.create_order(order_params, customer_id: customer.id)

        expect(result[:error]).to eq("You can add only one of the non-veg toppings in non-vegetarian pizza")
      end
    end

    context 'when selecting multiple crust types for a pizza' do
      it 'returns an error' do
        order_params = {
          items: [
            { pizza_id: vegetarian_pizza.id, size: "Medium", crust: ["Thin", "Thick"], extra_toppings: [] }
          ]
        }
    
        result = OrderService.create_order(order_params, customer_id: customer.id)
    
        expect(result[:error]).to eq("Only one type of crust can be selected for a pizza")
      end
    end
    

    context 'when ordering a large pizza' do
      it 'does not charge for toppings when it is a large pizza' do
        order_params = {
          items: [
            { pizza_id: vegetarian_pizza.id, size: "Large", crust: "Thin", extra_toppings: [paneer_topping.id, chicken_tikka_topping.id] }
          ]
        }

        result = OrderService.create_order(order_params, customer_id: customer.id)
        expect(result[:error]).to be_nil
        expect(result[:order].order_items.first.price).to eq(vegetarian_pizza.large_price)
      end
    end

    context 'when the customer does not exist' do
      it 'returns an error when the customer is not found' do
        order_params = {
          items: [
            { pizza_id: vegetarian_pizza.id, size: "Medium", crust: "Thin", extra_toppings: [] }
          ]
        }

        result = OrderService.create_order(order_params, customer_id: 9999)

        expect(result[:error]).to eq("Customer not found")
      end
    end

    context 'with valid order' do
      it 'creates an order successfully with valid customer and items' do
        Inventory.create(item_name: vegetarian_pizza.name, quantity: 10)
        Inventory.create(item_name: side.name, quantity: 10)
    
        order_params = {
          items: [
            { pizza_id: vegetarian_pizza.id, size: "Medium", crust: "Thin", extra_toppings: [] },
            { side_id: side.id }
          ]
        }
    
        result = OrderService.create_order(order_params, customer_id: customer.id)
    
        expect(result[:error]).to be_nil
        expect(result[:success]).to eq("Order placed successfully")
        expect(result[:order].customer).to eq(customer)
        expect(result[:order].order_items.count).to eq(2)
      end
    end   

    context 'with invalid order items' do
      it 'returns an error when an invalid pizza is selected' do
        order_params = {
          items: [
            { pizza_id: 9999, size: "Medium", crust: "Thin", extra_toppings: [] }
          ]
        }

        result = OrderService.create_order(order_params, customer_id: customer.id)

        expect(result[:error]).to eq("Invalid item selected")
      end
    end
  end
end
