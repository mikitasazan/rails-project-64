# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :posts, inverse_of: :category, dependent: :destroy
end
