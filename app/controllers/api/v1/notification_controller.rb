class Api::V1::NotificationController < Api::V1::BaseController
  # acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  acts_as_token_authentication_handler_for User
  before_action :set_user, only: [ :show, :update ]

  def show
  end

  def update
    @user.notification = params[:notification] == 'true'
    @user.save
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user  # For Pundit
  end
end