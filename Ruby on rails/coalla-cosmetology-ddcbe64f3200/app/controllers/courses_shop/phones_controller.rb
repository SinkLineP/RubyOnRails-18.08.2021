module CoursesShop
  class PhonesController < BaseController

    layout false

    before_action :authenticate_user!

    def create
      current_user.add_phone(phones_params[:number])

      redirect_to phones_params[:url]
    end

    private

    def phones_params
      params.require(:user_pay).permit(:url, :number)
    end
  end
end