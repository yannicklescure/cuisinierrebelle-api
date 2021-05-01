class Api::V1::NotificationController < Api::V1::BaseController
  # acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :authenticate_and_set_user
  # before_action :authenticate_user!

  def update
    # binding.pry
    # @user = User.find(params[:id])
    @user = current_user
    authorize @user  # For Pundit
    @user.notification = params[:notification] == 'true'
    @user.save
    render json: { notification: @user.notification }
  end
end
