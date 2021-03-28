require 'digest'
require 'json'

class Api::V1::PasswordController < Api::V1::BaseController
  respond_to :json

  def reset_user_password_verification
    # binding.pry
    @token = params[:user][:token]
    @user = User.find_by(password_reset_timestamp: @token)
    if @user.nil?
      puts "User not found"
      json_data = MultiJson.dump({
        user: {
          firstName: nil,
          email: nil,
          token: nil
        }
      })

      render json: json_data
    else
      authorize @user
      json_data = MultiJson.dump({
        user: {
          firstName: @user.first_name,
          email: @user.email,
          token: @token
        }
      })

      render json: json_data
    end
  end

  def reset_user_password
    # binding.pry
    @email = params[:user][:email]
    verification = Truemail.validate(@email)
    if (verification.result.success)
      @user = User.find_by(email: @email)
      authorize @user
      if (@user.password_reset_timestamp === params[:user][:token])
        if (params[:user][:password] === params[:user][:confirmation])
          @user.password = params[:user][:password]
          @user.password_reset_timestamp = '0'
          if @user.save
            render json: { success: true }
          else
            render json: { success: false }
          end
        end
      end
    end
  end

  def request_user_password_reset
    @email = params[:user][:email]
    verification = Truemail.validate(@email)
    if (verification.result.success)
      @user = User.find_by(email: @email)
      unless @user.nil?
        @token = Digest::SHA256.hexdigest(DateTime.now.strftime('%Q'))
        @user.password_reset_timestamp = @token
        @user.save
        UserMailer.with(user: @user, token: @token).reset_user_password.deliver_now
      end
      @user = NullObject.new if @user.nil?
      authorize @user
      json_data = MultiJson.dump({
        user: {
          email: @user.nil? ? nil : @email,
          token: @user.nil? ? nil : @token
        }
      })
      render json: json_data
    end
  end

end
