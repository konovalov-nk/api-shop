class UserMailer < Devise::Mailer
  default from: ENV['MAILER_DEFAULT_FROM_USERMAILER']

  def welcome_email(user)
    @user = user
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name, subject: 'Thank you for joining!')
  end

  def confirmation_instructions(record, token, opts = {})
    super
  end

  def reset_password_instructions(record, token, opts = {})
    super
  end

  def unlock_instructions(record, token, opts = {})
    super
  end
end
