class Chat < ApplicationRecord
  belongs_to :user
  has_many :posts
  validates :name, presence: true, length: { minimum: 5, maximum: 50 }
end
