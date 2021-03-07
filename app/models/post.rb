class Post < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  has_one_attached :image
  validate :acceptable_image
  validates_uniqueness_of :link, scope: :chat_id

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
  scope :auto_posted, -> { where(auto_posted: true) }
  scope :not_auto_posted, -> { where(auto_posted: nil).or(self.where(auto_posted: false)) }

  def acceptable_image
    return unless image.attached?

    errors.add(:image, 'is too big') unless image.byte_size <= 1.megabyte

    acceptable_types = %w[image/jpeg image/png]
    errors.add(:image, 'must be a JPEG or PNG') unless acceptable_types.include?(image.content_type)
  end
end
