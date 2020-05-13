class Player < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :rememberable, 
         :validatable

  has_many :games

  validates :nickname, uniqueness: true

  # not using emails
  def email_required?
    false
  end

  # not using emails
  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def current_game
    games.order(updated_at: :desc).first
  end
end
