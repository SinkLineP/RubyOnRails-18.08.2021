module Api
  class ApplicationController < ActionController::Base
    skip_before_filter :verify_authenticity_token
    skip_before_action :basic_authenticate

    before_filter :authenticate_account!

    layout false

    respond_to :json

    protected

    def authenticate_account!
      render json: {error: 'Incorrect token'} unless current_user
    end

    def current_user
      api_key = ApiKey.find_by_access_token(params[:token])
      return nil if api_key.blank?
      @user ||= api_key.user
    end
  end
end