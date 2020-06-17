class Review < ApplicationRecord
	belongs_to :product

	validates :title, presence: true
	validates :rating, presence: true
	validates :description, presence: true
end
