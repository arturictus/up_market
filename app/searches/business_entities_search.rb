class BusinessEntitiesSearch
  attr_reader :params, :errors, :result
  def initialize(params)
    validator = Validator.new.call(params)
    @params = validator.to_h
    @errors = validator.errors.to_h
  end

  def self.from_params(params)
    case params
    when ActionController::Parameters
      params = params.permit(:remaining_supply,
                             :owner_id).to_h
    when Hash
      params = params
    else
      params = {}
    end
    new(params)
  end

  def valid?
    @errors.empty?
  end

  def filter
    if valid?
      businesses = BusinessEntity.all
      businesses = apply_supply_filter(businesses)
      businesses = apply_owner_filter(businesses)
      @result = businesses
    else
      @result = []
      false
    end
  end


  private

  def apply_supply_filter(businesses)
    if params[:remaining_supply] == true
      businesses = businesses.where("share_supply > sold_supply")
    elsif params[:remaining_supply] == false
      businesses = businesses.where("share_supply <= sold_supply")
    end

    businesses
  end

  def apply_owner_filter(businesses)
    if params[:owner_id].present?
      businesses = businesses.where(business_owner_id: params[:owner_id])
    end
    businesses
  end

  class Validator < Dry::Validation::Contract
    params do
      optional(:remaining_supply).value(:bool)
      optional(:owner_id).value(:integer)
    end
  end
end
