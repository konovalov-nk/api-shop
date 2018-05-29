require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create :user }
  let(:welcome_mail) { UserMailer.welcome_email user }

  context 'welcome_email' do
    it 'renders the subject' do
      expect(welcome_mail.subject).to eql('Thank you for the registration!')
    end

    it 'renders the receiver email' do
      expect(welcome_mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(welcome_mail.from).to eql([ENV['MAILER_DEFAULT_FROM_USERMAILER']])
    end

    it 'assigns @name' do
      expect(welcome_mail.body.encoded).to match(user.first_name)
    end

    it 'uses correct template' do
      expect(welcome_mail.body.encoded).to match('Thank you for becoming a registered user')
    end

    it 'should send one email' do
      assert_emails 1 do
        welcome_mail.deliver_now
      end
    end

    # it 'assigns @confirmation_url' do
    #   expect(welcome_mail.body.encoded).to match("http://aplication_url/#{user.id}/confirmation")
    # end
  end
end
