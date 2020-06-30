# frozen_string_literal: true

# Handles shoppingcart's item requests
class ShoppingcartItemsController < ApplicationController
  before_action :set_shoppingcart_item, only: %i[show update destroy]

  # GET /shoppingcart_items
  def index
    @shoppingcart_items = ShoppingcartItem.all

    render json: @shoppingcart_items
  end

  # GET /shoppingcart_items/1
  def show
    render json: @shoppingcart_item
  end

  # POST /shoppingcart_items
  def create
    @shoppingcart_item = ShoppingcartItem.new(shoppingcart_item_params)

    if @shoppingcart_item.save
      render json: @shoppingcart_item.as_json(include: :menu), status: :created
    else
      render json: @shoppingcart_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shoppingcart_items/1
  def update
    if @shoppingcart_item.update(shoppingcart_item_params)
      render json: @shoppingcart_item
    else
      render json: @shoppingcart_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shoppingcart_items/1
  def destroy
    @shoppingcart_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shoppingcart_item
    @shoppingcart_item = ShoppingcartItem.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def shoppingcart_item_params
    params.require(:shoppingcart_item).permit(
      :shoppingcart_id, :menu_id, :quantity
    )
  end
end
