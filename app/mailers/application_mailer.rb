class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_USER']
  layout "mailer"
end
