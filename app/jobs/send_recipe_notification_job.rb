class SendRecipeNotificationJob < ApplicationJob
  queue_as :default

  def perform(args={})
    users = args[:users]
    recipe = args[:recipe]
    users.where(notification: true).each do |user|
      verification = Truemail.validate(user.email)
      if (verification.result.success)
        UserMailer.with(user: user, recipe: recipe).recipe.deliver_later
      else
        user.notification = false
        user.save
      end
    end
  end
end
