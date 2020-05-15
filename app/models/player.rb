class Player < ApplicationRecord
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :registerable,
         :rememberable, 
         :validatable

  has_many :games

  validates :nickname, uniqueness: true

  ### to Devise Token Auth to work

  def current_game
    games.order(updated_at: :desc).first
  end

  def confirmed_at
    true
  end
end
