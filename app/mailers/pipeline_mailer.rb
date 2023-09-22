class PipelineMailer < ApplicationMailer

    def status_email
        @user = params[:user]
        @status = params[:status]
        mail(to: @user.email, subject: 'Task Status: ' + @status)
    end
end
