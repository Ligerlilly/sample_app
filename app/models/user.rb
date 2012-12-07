# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, 
  has_secure_password
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_confirmation, presence: true, unless: Proc.new { |user| user.password.nil? }
  has_many :microposts, dependent: :destroy
  
  def send_password_reset
    generate_password_reset_token
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end
  
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
    def generate_password_reset_token
      self.password_reset_token = SecureRandom.urlsafe_base64
    end
end
