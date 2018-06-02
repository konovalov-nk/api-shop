require 'active_support/inflector'
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    @user = FactoryBot.create(:user)
    UserMailer.welcome_email(@user)
  end

  def order_received
    @user = FactoryBot.create(:user)
    @order = FactoryBot.create(:order_with_items)
    UserMailer.order_received(@user, @order)
  end

  def order_paid
    @user = FactoryBot.create(:user)
    @order = FactoryBot.create(:order_with_items)
    UserMailer.order_paid(@user, @order)
  end

  def order_updated
    @user = FactoryBot.create(:user)
    @order = FactoryBot.create(:order_with_items)
    UserMailer.order_updated(@user, @order)
  end

  def confirmation_instructions
    @user = FactoryBot.create(:user)
    UserMailer.confirmation_instructions(@user, {})
  end

  def reset_password_instructions
    @user = FactoryBot.create(:user)
    UserMailer.reset_password_instructions(@user, {})
    super
  end

  def unlock_instructions
    @user = FactoryBot.create(:user)
    UserMailer.unlock_instructions(@user, {})
    super
  end
end
