class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy 
  has_one_attached :avatar
  has_secure_password

  attr_accessor :remember_token
	before_save { email.downcase! }

	validates :name, length: { minimum: 3 }, uniqueness: true
  validates :email, length: { minimum: 5 },  
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }


  #return digest of string
	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #return random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #Remember user in the db for use in a permanent session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #return true if token = digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
 end