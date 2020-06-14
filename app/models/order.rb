class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :card_number,
    presence: true,
    length: { is: 16 }, 
    format: { with: /[0-9]{16}/ }
    :on => :update

  validates :card_expiration_date,
    presence: true

  validates :card_cvv,
    presence: true,
    length: { is: 3 },
    format: { with: /[0-9]{3}/ }
    :on => :update

  validates :address,
    presence: true
  
  validates :city,
    presence: true

  validates :zip_code
    presence: true,
    format: { with: /[\d]{5}\-/[\d]*/ }

  validates :guest_name
    presence: true

  validates :email
    presence: true,
    format: { with: /.+@.+\..+/ }

  validates :phone_num
    presence: true,
    format: { with: /^.*(\d{3}).*(\d{3}).*(\d{4})$/ }
end
