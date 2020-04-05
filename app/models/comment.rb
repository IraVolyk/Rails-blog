class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :commenter, length: { minimum: 3 }
  validates :body, length: { minimum: 2 }
end
