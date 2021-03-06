# frozen_string_literal: true

# Handles order requests
class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]
  before_action :authorize_entity

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders.as_json(include: :order_status)
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    # User or Guest must be logged in
    # We need to pass the token as a query param
    @order = Order.new(authenticate_params)
    @order.order_status_id = OrderStatus::PENDING
    if @order.save
      return render json: @order, status: :created, location: @order
    else
      return render json: @order.errors, status: :unprocessable_entity
    end
    return render json: authorize_entity
  end

  # PATCH/PUT /orders/1
  def update
    # TODO: Fix update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    # params.require(:order).permit(:total, :shoppingcart_id) # Before on the fly order creation
    params.require(:order).permit(:payload)
  end

  def authenticate_params
    token = decrypte_message params[:token]
    unless token['token'] != Rails.application.credentials.secret_key_base
      return {
        total: token['total'],
        shoppingcart_id: token['shoppingcart_id']
      }
    end

    render json: ['Tokens dont match'], status: :unprocessable_entity
    nil
  end
end
