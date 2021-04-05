class WelcomeController < AppController
  skip_before_action :authenticate_user!, only: [:index]
  skip_after_action :verify_policy_scoped, :only => :index

  def index
  end
end
