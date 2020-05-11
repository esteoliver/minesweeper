class ProfilesController < ApplicationController

  before_action :authenticate_player!

  def show; end

  private

  def is_me?
    params[:id] == 'me'
  end

end
