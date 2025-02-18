class BusinessEntitiesController < ApplicationController
  before_action :get_business_entity, only: [ :show, :create_order ]

  def index
    @businesses = BusinessEntity.with_remaining_supply().preload(:orders)
    render json: { data: @businesses }, status: :ok
  end

  def show
    render json: { data: { business_entity: @business, orders: @business.orders } }, status: :ok
  end

  # TODO: move to Order controller
  def create_order
    get_buyer()
    if order = Order.create(business_entity: @business, buyer: @buyer, **order_params)
      render json: { data: order }, status: :created
    else
      render json: { error: "Order could not be placed", data: nil }, status: :unprocessable_entity
    end
  end

  private

  def get_business_entity
    @business = BusinessEntity.find(params.expect(:id))
  end

  def get_buyer
    @buyer = Buyer.find(params.expect(:buyer_id))
  end

  def order_params
    params.require(:order).permit(:shares, :price_per_share)
  end
end
