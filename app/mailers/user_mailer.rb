class UserMailer < ApplicationMailer
    def authenticate
        @user = params[:user]
        @token = CGI.escape params[:user_token]
        @redirect_path = params[:redirect_url]
        mail(to: @user.email, subject: 'This is my first user test')
    end
end
