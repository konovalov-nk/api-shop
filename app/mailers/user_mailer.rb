class UserMailer < ApplicationMailer
  default from: ENV['MAILER_DEFAULT_FROM_USERMAILER']

  def welcome_email(user)
    @user = user
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name, subject: 'Thank you for the registration!')
  end
end
