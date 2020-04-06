class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :body, length: { minimum: 2 }
end
