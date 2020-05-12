class ApiController < ApplicationController
  include RenderJsonapi
  include ApiErrorHandling

  protect_from_forgery unless: -> { request.format.json? }
end
