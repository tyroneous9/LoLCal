class BuildsController < ApplicationController
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      @builds = user.builds
    else
      @builds = Build.all
    end
  end

  def new
    @build = Build.new
    @users = User.all
  end

  before_action :authenticate_user!, only: [:create]
  def create
    if user_signed_in?
      ActiveRecord::Base.transaction do
        new_build = Build.create!(build_params.merge(user_id: current_user.id))
        if params[:build_items].present?
          params[:build_items].each do |item_param|
            new_build.build_items.create!(item_param.permit(:item_id))
          end
        end

        render json: { message: 'New build added to db', build_id: new_build.id }, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: "Login to save builds" }, status: :unauthorized
    end
  end

  def show
    @build = Build.find(params[:id])
  end

  def edit
    @build = Build.find(params[:id])
    @users = User.all
  end

  def update
    @build = Build.find(params[:id])
    if @build.update(build_params)
      redirect_to build_path(@build), notice: 'Build was updated.'
    else
      render :edit
    end
  end

  def destroy
    @build = Build.find(params[:id])
    @build.destroy
    redirect_to @build, notice: 'Build was destroyed.'
  end

  private

  def build_params
    params.require(:build).permit(:name)
  end
end
