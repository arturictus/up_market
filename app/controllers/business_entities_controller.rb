class BusinessEntitiesController < ApplicationController
  before_action :get_business_entity, only: [ :show ]

  def index
    search = BusinessEntitiesSearch.from_params(params)
    if search.filter
      render json: { data: search.result }, status: :ok
    else
      render json: { error: "Invalid search parameters", data: [], errors: search.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: { business_entity: @business, orders: @business.orders } }, status: :ok
  end

  private

  def get_business_entity
    @business = BusinessEntity.find(params.expect(:id))
  end
end
