class Api::V1::SettingsController < Api::V1::BaseController
  before_action :authenticate_and_set_user

  def photo
    # binding.pry
    @user = current_user
    authorize @user
    params[:user] = {
      image: clean_params(params[:image])
    }
    if params[:image] == "[object Object]"
      params[:image] = @user.image
    end
    if @user.update(user_params)
      # binding.pry
      # create_json_cache(@user)
      render json: {
        image: {
          full: {
            url: @user.image.url(:full)
          },
          openGraph: {
            url: @user.image.url(:open_graph)
          },
          preview: {
            url: @user.image.url(:preview)
          },
          thumb: {
            url: @user.image.url(:thumb)
          }
        },
        user_id: @user.id
      }
    end
  end

  private

  def clean_params(params)
    params === "null" ? nil : params
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :image)
  end

  # def create_json_cache(resource)
  #   # binding.pry
  #   resource.updated_at = DateTime.now
  #   resource.save
  # end

  # def render_error
  #   render json: { errors: @post.errors.full_messages },
  #     status: :unprocessable_entity
  # end
end
