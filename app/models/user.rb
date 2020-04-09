class User < ApplicationRecord

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy 

  attr_accessor :remember_token
	before_save { email.downcase! }

	validates :name, length: { minimum: 3 }, uniqueness: true

  validates :email, length: { minimum: 5 }, 
            # format: {with /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, 
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", thumbnail: "30x30>" }, default_url: "/system/users/avatars/default_avatar.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

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