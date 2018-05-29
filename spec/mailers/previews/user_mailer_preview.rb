# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    @user = FactoryBot.create(:user)
    UserMailer.welcome_email(@user)
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
