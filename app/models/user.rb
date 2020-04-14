class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { email.downcase! }
  # create act digest before create user
  before_create :create_activation_digest

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy 
  has_one_attached :avatar
  has_secure_password

	validates :name, length: { minimum: 3 }, uniqueness: true
  validates :email, length: { minimum: 5 },  
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  #return digest of string (token) to be available to save it to db
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #return new safe random token (string) 
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #Remember user in the db for use in a permanent session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #return true if token = digest
   def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #forget user
  def forget
    update_attribute(:remember_digest, nil)
  end

    #Creates and assigns an activation token and digest
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  #Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  private

  def downcase_email
    self.email = email.downcase
  end

 end