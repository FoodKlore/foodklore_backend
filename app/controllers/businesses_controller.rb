class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :update, :destroy]

  def index
    @businesses = Business.all
    render json: @businesses
  end

  def show
    render json: @business
  end

  def update
    if @business.update(business_params)
      render json: @business
    else
      render json: @business, status: :unprocessable_entity
    end
  end

  def create
    @business = Business.new(business_params)
    if @business.save
      render json: @business, status: :created
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  private
    def set_business
      @business = Business.find(params[:id])
    end

    def business_params
      params.require(:business).permit(
        :business_name,
        :phone_number,
        :direction,
        :business_description,
        :img
      )
    end
end
