# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :category, inverse_of: :posts

  has_many :comments, class_name: "PostComment", inverse_of: :post, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :body, presence: true, length: { minimum: 200, maximum: 4000 }
end
