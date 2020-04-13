class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable 
  belongs_to :user
  validates :body, length: { minimum: 2 }
  validates :user_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
