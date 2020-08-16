class GuestMailer < ApplicationMailer

    def authenticate
        @guest = params[:guest]
        @security_code = params[:security_code]
        @token = CGI.escape params[:token]
        @redirect_path = params[:redirect_url]
        mail(to: @guest.email, subject: 'This is my first test')
    end
end
