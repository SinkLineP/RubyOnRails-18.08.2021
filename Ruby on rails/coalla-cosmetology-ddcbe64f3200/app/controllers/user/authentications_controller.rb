class User::AuthenticationsController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    authentication = current_user.authentications.find_by!(provider: params[:id])
    authentication.destroy
    redirect_to edit_profile_path
  end
end
