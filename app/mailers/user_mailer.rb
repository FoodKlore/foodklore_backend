class UserMailer < ApplicationMailer
    def authenticate
        @user = params[:user]
        mail(to: @user.email, subject: 'This is my first user test')
    end
end
