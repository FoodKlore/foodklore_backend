class OrderStatus < ApplicationRecord
  has_many :orders

  PENDING = 1
  CANCELLED = 2
  PROCESSED = 3

end
