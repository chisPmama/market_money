class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def unprocessable_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    .serialize_json, status: :bad_request
  end

  def unprocessable_entity(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 422))
    .serialize_json, status: :unprocessable_entity
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 404))
    .serialize_json, status: :not_found
  end

  def unprocessable_response_404(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end
end
