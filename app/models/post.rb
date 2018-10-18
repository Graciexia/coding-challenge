class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :comments, dependent: :destroy
end
