# frozen_string_literal: true

# Handles shopping cart
class ShoppingcartController < ApplicationController
  before_action :set_shoppingcart, only: %i[update show destroy]

  def index
    # Get last shopping cart which order hasn't been processed or hasn't been cancelled
    render json: Shoppingcart.left_outer_joins(:orders)
                             .where("orders.id": nil).as_json(
                               include: { shoppingcart_items: {
                                 include: :menu
                               } }
                             )[0]
    # TODO: I previously added .or(Shoppingcart.left_outer_joins(:orders)
    # .where("orders.order_status_id": OrderStatus::PENDING)),
    # this could be used if we want them to have the ability to add/edit to an
    # existing order that hasn't been proccessed
  end

  def create
    @shoppingcart = Shoppingcart.new(shoppingcart_params)

    if @shoppingcart.save
      render json: @shoppingcart, status: :created, location: @shoppingcart
    else
      render json: @shoppingcart, status: :unprocessable_entity
    end
  end

  def show
    render json: @shoppingcart
  end

  def destroy
    @shoppingcart.destroy
  end

  private

  def set_shoppingcart
    @shoppingcart = Shoppingcart.find(params[:id])
  end

  def shoppingcart_params
    params.require(:shoppingcart).permit(:authenticable)
  end
end
