class SendRecipeNotificationJob < ApplicationJob
  queue_as :default

  def perform(args={})
    users = JSON.parse(args[:users])
    recipe = Recipe.find(JSON.parse(args[:recipe])['id'])
    # binding.pry
    # users.where(notification: true).each do |user|
    if (users.length > 0)
      users.each do |user|
        # puts user['notification']
        this_user = User.find(user['id'])
        if (this_user['notification'])
          verification = Truemail.validate(this_user['email'])
          if (verification.result.success)
            # puts this_user['email']
            UserMailer.with(user: this_user, recipe: recipe).recipe.deliver_later
          else
            this_user.notification = false
            this_user.save
          end
        end
      end
    end
  end
end
