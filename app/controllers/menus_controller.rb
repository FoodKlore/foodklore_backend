class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :update, :destroy]

  def index
    @menu = Menu.all

    render json: @menu
  end

  def show
    @menu_with_ingredients = @menu.as_json
    @menu_with_ingredients[:ingredients] = @menu.ingredients
    render json: @menu_with_ingredients
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      render json: @menu, status: :created
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  def update
    if @menu.update(menu_params)
      render json: @menu
    else
      render json: @menu, status: :unprocessable_entity
    end
  end

  def destroy
    # if @menu.destroy

    # else

    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(
        :name, :description, :img, :total, :created_at, :updated_at, :business_id
      )
    end
end
