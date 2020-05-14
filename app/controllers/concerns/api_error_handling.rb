module ApiErrorHandling
  extend ActiveSupport::Concern

  included do

    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
    rescue_from ActiveRecord::RecordInvalid, :with => :record_invalid
    rescue_from ActionController::ParameterMissing, :with => :param_missing

    def param_missing(error)
      render json: {
        errors: [
          {
            title: "Bad request",
            status: '400',
            detail: error.message
          }
        ],
        data: []
      }, status: :bad_request
    end

    def record_invalid(error)
      render json: {
        errors: [
          {
            title: "Invalid record",
            status: '422',
            detail: error.message
          }
        ],
        data: []
      }, status: :unprocessable_entity
    end

    def record_not_found(error)
      render json: {
        errors: [
          {
            title: error.message,
            status: '404',
            detail: "Couldn\'t found #{error.model.downcase} with #{error.primary_key} = #{error.id}"
          }
        ],
        data: []
      }, status: :not_found
    end
  end
end