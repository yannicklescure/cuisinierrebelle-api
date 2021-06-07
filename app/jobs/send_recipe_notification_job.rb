class SendRecipeNotificationJob < ApplicationJob
  queue_as :default

  def perform(args={})
    @recipe = Recipe.find(JSON.parse(args[:recipe])['id'])

    @recipe.user.followers.each do |user|
      if (user.notification)
        UserMailer.with(user: user, recipe: @recipe).recipe.deliver_later
      end
    end
  end
end
