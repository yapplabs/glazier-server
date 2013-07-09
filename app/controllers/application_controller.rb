require 'authentication'

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Authentication

  private
  def exception_message(exception)
    message = "\n#{exception.class} (#{exception.message}):\n"
    message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
    message << "  " << exception.backtrace.join("\n  ")
  end

  def log_fatal(exception)
    message = exception_message(exception)
    logger.fatal("#{message}\n\n")
  end

  def render_internal_error_json(exception)
    if Rails.env.development?
      render json: {
        error: exception.message,
        exception: exception.class.to_s,
        backtrace: exception.backtrace
      }, status: 500
    else
      render json: {
        :error => 'Internal server error'
      }, status: 500
    end
  end

  def authenticate_user
    head :unauthorized unless current_user.present?
  end
end
