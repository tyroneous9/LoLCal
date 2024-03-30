class BuildItemsController < ApplicationController
  def index
    @build_items = BuildItem.all
    render json: @build_items, include: [:item]
  end

  def show
    build_item = BuildItem.find(params[:id])
    render json: @build_items, include: [:item]
  end

  # def create
  #   params.require(:build_items).each do |build_item_param|
  #     BuildItem.create(build_item_params(build_item_param))
  #   end
  #   render json: { message: 'Build added to db' }, status: :created
  # rescue => e
  #   render json: { error: e.message }, status: :unprocessable_entity
  # end

  # private

  # def build_item_params(build_item_param)
  #   build_item_param.permit(:build_id, :item_id)
  # end

end
