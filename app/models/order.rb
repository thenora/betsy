class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :card_number,
    presence: true,
    length: { is: 16 }, 
    format: { with: /[0-9]{16}/ },
    :on => :update

  validates :card_expiration_date,
    presence: true,
    :on => :update

  validates :card_cvv,
    presence: true,
    length: { is: 3 },
    format: { with: /[0-9]{3}/ },
    :on => :update

  validates :address,
    presence: true,
    :on => :update
  
  validates :city,
    presence: true,
    :on => :update

  validates :zip_code,
    presence: true,
    format: { with: /[\d]{5}\-[\d]*/ },
    :on => :update

  validates :guest_name,
    presence: true,
    :on => :update

  validates :email,
    presence: true,
    format: { with: /.+@.+\..+/ },
    :on => :update

  validates :phone_num,
    presence: true,
    format: { with: /\A.*(\d{3}).*(\d{3}).*(\d{4})\z/ },
    :on => :update


  def total_price
    total = 0.0

		self.order_items.each do |item|
			total += item.price
		end

		return total
  end
end
