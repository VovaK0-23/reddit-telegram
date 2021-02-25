class Chat < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  validates :name, presence: true, length: { minimum: 5, maximum: 50 }, uniqueness: true, format: { with: /\A@/}
  validates :subreddit, presence: true, length: { minimum: 5, maximum: 50 }, format: { with: /\Ar\//}
end
