class AppController < ApplicationController

  def landing
    redirect_to '/profiles/me' if player_signed_in?
  end
end
