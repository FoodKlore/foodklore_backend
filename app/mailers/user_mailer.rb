class UserMailer < ApplicationMailer
    def authenticate
        @user = params[:user]
        @token = params[:user_token]
        mail(to: @user.email, subject: 'This is my first user test')
    end
end
