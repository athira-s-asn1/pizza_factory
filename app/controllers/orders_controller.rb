class OrdersController < ApplicationController
  def create
    result = OrderService.create_order(order_params, customer_id: params[:customer_id])
    
    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      render json: { order: format_order_response(result[:order]), message: result[:success] }, status: :created
    end
  end

  private

  def order_params
    params.require(:order).permit(items: [:pizza_id, :side_id, :size, :crust, extra_toppings: []])
  end

  def format_order_response(order)
    {
      id: order.id,
      customer_name: order.customer.name,
      items: order.order_items.map do |item|
        {
          pizza_name: item.pizza&.name,
          side_name: item.side&.name,
          size: item.size,
          crust: item.crust,
          price: item.price
        }
      end,
      total_price: order.order_items.sum(&:price)
    }
  end
end
