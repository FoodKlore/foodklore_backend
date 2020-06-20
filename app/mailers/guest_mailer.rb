class GuestMailer < ApplicationMailer

    def authenticate
        @guest = params[:guest]
        @security_code = params[:security_code]
        @url = 'http://localhost:3000'
        mail(to: @guest.email, subject: 'This is my first test')
    end
end
