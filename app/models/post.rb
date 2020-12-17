class Post < ApplicationRecord
  belongs_to :user

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
end
