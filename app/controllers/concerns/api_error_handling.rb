module ApiErrorHandling
  extend ActiveSupport::Concern

  included do

    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    def record_not_found(error)
      render json: {
        errors: [
          {
            title: "#{error.model.capitalize} not found",
            status: '404',
            detail: "Couldn\'t found #{error.model.downcase} with #{error.primary_key} = #{error.id}"
          }
        ],
        data: []
      }, status: :not_found
    end
  end
end