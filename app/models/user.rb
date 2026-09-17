# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, inverse_of: :creator, foreign_key: "creator_id", dependent: :destroy
  has_many :comments, class_name: "PostComment", inverse_of: :user, dependent: :destroy
  has_many :likes, class_name: "PostLike", inverse_of: :user, dependent: :destroy
end
