class Article < ApplicationRecord
	has_many :comments, as: :commentable, dependent: :destroy
	belongs_to :user 
	validates :title, presence: true,
                    length: { minimum: 5 }
    validates :user_id, presence: true        
    default_scope -> { order(created_at: :desc) }       
end
