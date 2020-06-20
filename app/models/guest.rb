class Guest < ApplicationRecord
    has_secure_password :security_code, validations: false
    # validates :security_code, uniqueness: true
    # validates :security_code, presence: true

    before_create :set_guest_token

    # TODO: Figure out a way to do secure code here but also emailing the secure code
    def set_secure_code
        self.secure_code = generate_secure_code
    end

    def generate_secure_code
        loop do
            secure_code = SecureRandom.random_number(9e5).to_i.to_s
            break secure_code unless Guest.where(secure_code: secure_code).exists?
        end
    end

    def set_guest_token
        self.guest_token = generate_token
    end

    def generate_token
        loop do
            token = SecureRandom.hex(25)
            break token unless Guest.where(guest_token: token).exists?
        end
    end
end
