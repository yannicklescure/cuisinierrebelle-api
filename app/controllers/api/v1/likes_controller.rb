class Api::V1::LikesController < Api::V1::BaseController
  before_action :authenticate_and_set_user
  # before_action :authenticate_user!
  # protect_from_forgery with: :null_session

  def create
    # binding.pry
    # token   = request.headers.fetch("Authorization", "").split(" ").last
    # payload = JWT.decode(token, nil, false)
    # @user = User.find(payload[0]["sub"])
    @like = Like.new(like_params)
    authorize @like
    @like.save
    head :no_content
    # render json: MultiJson.dump({})
  end

  def destroy
    # binding.pry
    @recipe = Recipe.find(params[:id])
    @user = current_user
    @like = Like.find_by(user: @user, recipe: @recipe)
    authorize @like
    @like.destroy
    head :no_content
  end

  private

  def like_params
    params.require(:like).permit(:recipe_id, :user_id)
  end

end
