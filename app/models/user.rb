class User < ActiveRecord::Base
  before_save { email.downcase! }
  before_create :create_hashed_token

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }

  has_secure_password

  def User.new_raw_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(raw_token)
    Digest::SHA1.hexdigest(raw_token.to_s)
  end

  def student?
    type == "Student"
  end

  def teacher?
    type == "Teacher"
  end

  private

    def create_hashed_token
      self.hashed_token = User.digest(User.new_raw_token)
    end
end
