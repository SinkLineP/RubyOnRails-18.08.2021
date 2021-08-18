module Admin
  class UsersController < AdminController
    def search
      users = User.order(:last_name, :first_name, :middle_name)
      users = users.where("concat_ws(' ', id, amocrm_id, email, last_name, first_name, middle_name, array_to_string(emails, ' ')) ilike ?", "%#{params[:term]}%") if params[:term].present?
      render json: users.first(LIST_SIZE).map { |user| { value: "#{user.full_name}, #{user.model_name.human}", id: user.id } }
    end
  end
end