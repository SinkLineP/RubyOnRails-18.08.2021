class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def edit
    authorize! :read, :profile
  end

  def update
    current_user.reload
    old_version = params[:version].to_i
    Rails.logger.info("Profile version: #{current_user.version}, was: #{old_version}")
    if current_user.version > params[:version].to_i
      flash[:profile_alert] = 'Мы не можем сохранить изменения, так как данные вашего профиля уже были изменены администратором. Пожалуйста, повторите ваши действия ещё раз.'
      redirect_to edit_profile_path
      return
    end

    if student_params[:password].blank? and student_params[:password_confirmation].blank?
      current_user.update_without_password(student_params)
    else
      if current_user.update(student_params)
        sign_in(current_user, bypass: true)
      end
    end

    render :edit
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :password, :password_confirmation, :has_blog_subscription,
                                    document_copies_attributes: [:id, :_destroy, :file_cache],
                                    student_documents_attributes: [:id, :_destroy, :document_type, :file_cache, :title],
                                    user_phones_attributes: [:id, :number, :_destroy])
  end

end