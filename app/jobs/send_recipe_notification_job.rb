class SendRecipeNotificationJob < ApplicationJob
  queue_as :default

  def perform(args={})
    # users = JSON.parse(args[:users])
    @recipe = Recipe.find(JSON.parse(args[:recipe])['id'])
    # users: @recipe.user.followers.to_json, recipe: @recipe.to_json
    # binding.pry
    # users.where(notification: true).each do |user|
    @recipe.user.followers.each do |user|
      if (user.notification)
        UserMailer.with(user: user, recipe: @recipe).recipe.deliver_later
        # verification = Truemail.validate(user['email'])
        # if (verification.result.success)
        #   UserMailer.with(user: user, recipe: @recipe).recipe.deliver_later
        # else
        #   user.notification = false
        #   user.save
        # end
      end
    end
  end
end
