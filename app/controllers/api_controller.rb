class ApiController < ApplicationController  
  include RenderJsonapi
  include ApiErrorHandling

  protect_from_forgery unless: -> { request.format.json? }

  before_action :set_anonymous_player, unless: :player_signed_in?
  before_action :paginate, only: :index

  private

  def paginate
    params[:page] = 1 if params[:page].blank?
    params[:page] = params[:page].to_i if params[:page].is_a? String
  end

  def set_anonymous_player
    @anonymous_player = session[:anonymous_player] || SecureRandom.uuid

    session[:anonymous_player] = @anonymous_player if session[:anonymous_player].nil?
  end
end
