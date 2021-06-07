class CleanUsers < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.all.each do |user|
      verification = Truemail.validate(user.email)
      unless (verification.result.success)
        user.destroy
      end
    end
  end
end
