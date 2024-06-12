class AdminMailer < ApplicationMailer
    default from: ENV['MAIL_USER']
    layout 'mailer'
  
    def new_user_waiting_for_approval(email)
      @email = email
      admin_email = ENV['ADMIN_EMAIL']
      mail(to: admin_email, subject: 'New user awaiting admin approval')
    end

    def user_approved(email)
      mail(to: email, subject: 'Your account has been approved')
    end

end
