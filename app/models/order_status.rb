class OrderStatus < ApplicationRecord
  has_many :orders

  PENDING = 2
  CANCELLED = 3
  PROCESSED = 4

end
