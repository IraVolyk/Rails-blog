class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :body, length: { minimum: 2 }
  validates :user_id, presence: true
end
