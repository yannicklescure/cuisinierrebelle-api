class Api::V1::LikesController < Api::V1::BaseController
  before_action :authenticate_and_set_user
  # before_action :authenticate_user!
  # protect_from_forgery with: :null_session

  def create
    # binding.pry
    @recipe = Recipe.includes([:taggings]).find(params[:recipe_id])
    @user = current_user
    @like = Like.find_by(user: @user, recipe: @recipe)
    if @like.nil?
      @like = Like.new(like_params)
      authorize @like
      @like.save
    end
    head :no_content
    # render json: MultiJson.dump({})
  end

  def destroy
    # binding.pry
    @recipe = Recipe.includes([:taggings]).find(params[:id])
    @user = current_user
    @like = Like.find_by(user: @user, recipe: @recipe)
    unless @like.nil?
      authorize @like
      @like.destroy
    end
    head :no_content
  end

  private

  def like_params
    params.require(:like).permit(:recipe_id, :user_id)
  end

end
