class BusinessEntitiesController < ApplicationController
  def index
    search = BusinessEntitiesSearch.from_params(params)
    if search.filter
      render json: { data: search.result }, status: :ok
    else
      render json: { error: "Invalid search parameters", data: [], errors: search.errors }, status: :unprocessable_entity
    end
  end

  def show
    business = BusinessEntity.includes(:orders).find(params.expect(:id))
    render json: { data: { business_entity: business, orders: business.orders } }, status: :ok
  end
end
