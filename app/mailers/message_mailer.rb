class MessageMailer < ActionMailer::Base
  default from: "no-reply@topichog.com"
  
  def message_notification(message)
    @message = message
    mail to: 'support@topichog.com' , subject: message.name + " through contact form"
  end
end
