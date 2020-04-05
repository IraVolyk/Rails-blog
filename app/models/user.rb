class User < ApplicationRecord
  has_many :articles
  has_many :comments 

	before_save { self.email = email.downcase }

	validates :name, length: { minimum: 3 }, uniqueness: true

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { minimum: 5 }, 
            format: {with VALID_EMAIL}, 
            uniqueness: { case_sensitive: false }
            
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }


	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
 end