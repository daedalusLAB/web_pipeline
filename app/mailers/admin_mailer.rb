class AdminMailer < ApplicationMailer
    default from: ENV['EMAIL_FROM']
    layout 'mailer'
  
    def new_user_waiting_for_approval(email)
      @email = email
      admin_email = ENV['ADMIN_EMAIL']
      mail(to: admin_email, subject: 'New user awaiting admin approval')
    end
end