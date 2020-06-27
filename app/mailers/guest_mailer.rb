class GuestMailer < ApplicationMailer

    def authenticate
        @guest = params[:guest]
        @security_code = params[:security_code]
        @token = params[:token]
        mail(to: @guest.email, subject: 'This is my first test')
    end
end
