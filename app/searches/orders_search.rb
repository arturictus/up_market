class OrdersSearch
  attr_reader :params, :result, :errors

  def initialize(params)
    validator = Validator.new.call(params)
    @params = validator.to_h
    @errors = validator.errors.to_h
  end

  def self.from_params(params)
    params = case params
    when ActionController::Parameters
      params.permit(:business_entity_id,
                          :buyer_id,
                          :owner_id,
                          :sort_by,
                          :sort_order).to_h
    when Hash
      params
    else
      {}
    end
    new(params)
  end

  def valid?
    @errors.empty?
  end

  def filter
    if valid?
      orders = Order.all
      orders = apply_business_entity_filter(orders)
      orders = apply_buyer_filter(orders)
      orders = apply_owner_filter(orders)
      orders = apply_sorting(orders)
      @result = orders
    else
      @result = []
      false
    end
  end

  private

  def apply_business_entity_filter(orders)
    if params[:business_entity_id].present?
      orders = orders.where(business_entity_id: params[:business_entity_id])
    end
    orders
  end

  def apply_buyer_filter(orders)
    if params[:buyer_id].present?
      orders = orders.where(buyer_id: params[:buyer_id])
    end
    orders
  end

  def apply_owner_filter(orders)
    if params[:owner_id].present?
      orders = orders.joins(:business_entity).where("business_entities.business_owner_id = ?", params[:owner_id])
    end
    orders
  end

  def apply_sorting(orders)
    if params[:sort_by].present? && params[:sort_order].present?
      orders = orders.order(params[:sort_by] => params[:sort_order])
    end
    orders
  end

  class Validator < Dry::Validation::Contract
    params do
      optional(:business_entity_id).value(:integer)
      optional(:buyer_id).value(:integer)
      optional(:owner_id).value(:integer)
      optional(:sort_by).value(included_in?: %w[created_at shares price_per_share])
      optional(:sort_order).value(included_in?: %w[asc desc])
    end
  end
end
