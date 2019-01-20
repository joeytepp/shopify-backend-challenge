# frozen_string_literal: true

class Product < ApplicationRecord
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
  has_many :cart_products
  has_many :carts, through: :cart_products
end
