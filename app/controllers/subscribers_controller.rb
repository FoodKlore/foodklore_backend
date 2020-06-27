# frozen_string_literal: true

class SubscribersController < ApplicationController
  before_action :set_subscriber, only: %i[show update destroy]

  # GET /subscribers
  def index
    @subscribers = Subscriber.where(active: true)

    render json: @subscribers
  end

  # GET /subscribers/1
  def show
    render json: @subscriber
  end

  # POST /subscribers
  def create
    @subscriber = Subscriber.new(subscriber_params)
    if Subscriber.find_by(email: @subscriber.email)
      render json: @subscriber, status: :not_modified
    elsif @subscriber.save
      render json: @subscriber, status: :created, location: @subscriber
    else
      render json: @subscriber.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscribers/1
  def update
    if @subscriber.update(subscriber_params)
      render json: @subscriber
    else
      render json: @subscriber.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subscribers/1
  def destroy
    @subscriber.update(active: false)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def subscriber_params
    params.require(:subscriber).permit(:name, :email, :active, :created_at, :updated_at)
  end
end
