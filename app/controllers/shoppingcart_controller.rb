class ShoppingcartController < ApplicationController
  before_action :set_shoppingcart, only: [:edit, :update, :show, :destory]

  def index
    # Get last shopping cart which order hasn't been processed or hasn't been cancelled
    render json: Shoppingcart.left_outer_joins(:orders).where.not("orders.id": nil).where({ "orders.order_status_id": OrderStatus::PENDING }).as_json(include: { shoppingcart_items: {
      include: :menu
      }})[0]
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
    params.require(:shoppingcart)
  end
end
