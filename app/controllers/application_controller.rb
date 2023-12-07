class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  
end
