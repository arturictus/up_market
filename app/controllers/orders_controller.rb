class OrdersController < ApplicationController
  def index
    search = OrdersSearch.from_params(params)
    if search.filter
      render json: { data: search.result }, status: :ok
    else
      render json: { error: "Invalid search parameters", data: [], errors: search.errors }, status: :unprocessable_entity
    end
  end

  def create
    order = Order.new(order_params())
    if order.save
      render json: { data: order }, status: :created
    else
      render json: { error: "Order could not be placed", data: nil, errors: order.errors }, status: :unprocessable_entity
    end
  end

  def execute
    @order = Order.find(params.expect(:id))
    if @order.execute
      render json: { data: @order }, status: :ok
    else
      render json: { error: "Order could not be executed", data: nil, errors: @order.errors }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.expect(order: [ :shares, :price_per_share, :buyer_id, :business_entity_id ])
  end
end
