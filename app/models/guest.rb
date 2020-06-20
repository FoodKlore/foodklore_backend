class Guest < ApplicationRecord
    has_secure_password :security_code, validations: false

    # TODO: Do not expose security code, right now if you set a guest and do guest.security_code, it will give you the not encrypted security code
    # validates :security_code, uniqueness: true
    # validates :security_code, presence: true
end
