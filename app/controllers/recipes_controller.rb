class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # @recipes = Recipe.where(user: current_user)
    @recipes = policy_scope(Recipe).where(user: current_user)
    @bookmarks = Bookmark.where(user: current_user)
  end

  def show
    # @recipe = Recipe.find(params[:id])
    @recipe = Recipe.friendly.find(params[:id])
    @related_recipes = @recipe.find_related_tags
    authorize @recipe
    @bookmark = Bookmark.find_by(user: current_user, recipe: @recipe)
    @bookmarks = Bookmark.where(user: current_user)
    @like = Like.find_by(user: current_user, recipe: @recipe)
    @likes = Like.where(user: current_user, recipe: @recipe)
    @comment = Comment.new
  end

  def new
    @recipe = Recipe.new
    authorize @recipe
    @bookmarks = Bookmark.where(user: current_user)
  end

  def create
    @bookmarks = Bookmark.where(user: current_user)
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    authorize @recipe
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      render :new
    end
  end

  def edit
    @recipe = Recipe.friendly.find(params[:id])
    authorize @recipe
    @bookmarks = Bookmark.where(user: current_user)
  end

  def update
    @bookmarks = Bookmark.where(user: current_user)
    @recipe = Recipe.friendly.find(params[:id])
    authorize @recipe
    params_recipe_video = params[:recipe][:video]
    if params_recipe_video.match?(/(.+\/)(.+)/)
      share_link = params_recipe_video.match(/(.+\/)(.+)/)
      params_recipe_video = share_link[2] if share_link[1].match?(/https:\/\/youtu.be\//)
      if share_link[1].match?(/https:\/\/www.youtube.com\//)
        params_recipe_video = share_link[2].match(/(watch\?v=)(.+)/)[2]
      end
    end
    params[:recipe][:video] = "https://youtu.be/#{params_recipe_video}"
    # raise
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.friendly.find(params[:id])
    authorize @recipe
    @recipe.remove_photo
    @recipe.save
    @recipe.destroy
    redirect_to recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :subtitle, :video, :ingredients, :direction, :description, :photo, :image, :tag_list)
  end
end
