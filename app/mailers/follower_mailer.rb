class FollowerMailer < ActionMailer::Base
  default from: "john.costello@careergro.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.follower_mailer.follower_confirmation.subject
  #
  def follower_confirmation(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: follower.name + " followed you on TopicHog!"
  end
end
