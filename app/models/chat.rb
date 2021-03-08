class Chat < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  validates :name, presence: true, length: { minimum: 5, maximum: 50 }, uniqueness: true, format: { with: /\A@/}
  validates :subreddit, presence: true, length: { minimum: 5, maximum: 50 }, format: { with: /\Ar\//}
  validates :subreddit_sorting, presence: true, length: { maximum: 8 }
end
