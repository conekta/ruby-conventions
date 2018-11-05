class ApplicationController < ActionController::API

  include CanCan::ControllerAdditions

  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do |error|
    error_response = {
      level: "warning",
      message: "No #{error.model} found with ID '#{error.id}'",
      data: nil
    }
    error_response[:data] = error if Rails.env.development? || Rails.env.test?
    render json: error_response, status: 404
  end

  rescue_from ApiErrors::ApiError do |error|
    render json: { level: error.level, message: error.message, data: error.data }, status: error.status
  end

  rescue_from CanCan::AccessDenied do |error|
    render json: { level: :warning, message: "You are not authorized to access this resource", data: nil }, status: :forbidden
  end

  def current_user
    @current_user
  end

  protected

  def authenticate
    check_authentication_headers
    check_valid_user
    check_valid_token
  end

  def check_authentication_headers
    message = "This endpoint requires authentication, make sure you are sending the proper headers"
    raise ApiErrors::AuthenticationError.new(message) if request.headers["X-User-Email"].blank? || request.headers["X-User-Token"].blank?
  end

  def check_valid_user
    message = "Invalid credentials, please try again."
    raise ApiErrors::AuthenticationError.new(message) unless User.where(email: request.headers["X-User-Email"]).exists?
  end

  def check_valid_token
    user = User.find_by(email: request.headers["X-User-Email"])
    @current_user = user
    token = user.tokens.find_by(token: request.headers["X-User-Token"])

    message = if token.blank?
                "Invalid credentials, please try again."
              elsif token.present? && token.expired?
                "This #{token.token_type.humanize} token has expired. Please request a new one"
              end
    raise ApiErrors::AuthenticationError.new(message) if message.present?
  end

  def paginate(resource)
    response.set_header("X-Total-Pages", resource.pages)
    if params[:page].present?
      resource.page(params[:page].to_i)
    else
      resource.page(1)
    end
  end


end
