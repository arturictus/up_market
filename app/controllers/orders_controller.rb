class OrdersController < ApplicationController
  before_action :get_business_entity, only: [ :create ]
  def index
    search = OrdersSearch.from_params(params)
    if search.filter
      render json: { data: search.result }, status: :ok
    else
      render json: { error: "Invalid search parameters", data: [], errors: search.errors }, status: :unprocessable_entity
    end
  end

  def create
    get_buyer()
    if order = Order.create(order_params())
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

  def get_business_entity
    @business = BusinessEntity.find(params.expect(:business_id))
  end

  def get_buyer
    @buyer = Buyer.find(params.expect(:buyer_id))
  end

  def order_params
    params.require(:order).permit(:shares, :price_per_share, buyer_id: @buyer.id, business_entity_id: @business.id)
  end
end
