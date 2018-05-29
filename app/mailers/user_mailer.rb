class UserMailer < ApplicationMailer
  default from: ENV['MAILER_DEFAULT_FROM_USERMAILER']

  def welcome_email(user)
    @user = user
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name,
         template_path: 'user_mailer',
         template_name: 'welcome_email',
         subject: 'Thank you for the registration!')
  end

  def confirmation_instructions(record, token, opts={})
    welcome_email(record)
  end

  def reset_password_instructions(record, token, opts={})
    # welcome_email(record)
  end

  def unlock_instructions(record, token, opts={})
    # welcome_email(record)
  end
end
