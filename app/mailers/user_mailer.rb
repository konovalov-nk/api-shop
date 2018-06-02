require 'user_mailer_helper'

class UserMailer < Devise::Mailer
  include UserMailerHelper
  helper UserMailerHelper
  default from: ENV['MAILER_DEFAULT_FROM_USERMAILER']

  def welcome_email(user)
    @user = user
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name, subject: 'Thank you for joining!')
  end

  def order_paid(user, order)
    @user = user
    @order = order
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name, subject: "We have received your payment for the order ##{order.invoice}.")
  end

  def order_received(user, order)
    @user = user
    @order = order
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name, subject: 'We have received your order.')
  end

  def order_updated(user, order)
    @user = user
    @order = order
    email_with_name = %("#{user.full_name}" <#{user.email}>)
    mail(to: email_with_name, subject: "You have updated your order ##{order.invoice}.")
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
