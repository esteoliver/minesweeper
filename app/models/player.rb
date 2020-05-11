class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :rememberable, 
         :validatable

  validates :nickname, uniqueness: true

  # not using emails
  def email_required?
    false
  end

  # not using emails
  def email_changed?
    false
  end
end
