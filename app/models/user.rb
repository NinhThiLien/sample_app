class User < ApplicationRecord
  before_save :email_save

  validates :name, presence: true, length: {maximum: Settings.maximum.name_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            length: {maximum: Settings.maximum.email_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.minimum.password_length}

  has_secure_password

  private

  def email_save
    email.downcase!
  end
end
