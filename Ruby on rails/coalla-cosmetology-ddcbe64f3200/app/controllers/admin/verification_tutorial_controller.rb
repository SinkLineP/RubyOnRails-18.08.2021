# Контроллер раздела "Дипломы"
# @see app/views/admin/verification_tutorial
module Admin
  class VerificationTutorialController < AdminController
    set_current_shop_for_model(Lookup)

    before_action do
      authorize! :manage, :verification_tutorial
      @tutorial = Lookup.find_by(code: 'verification_tutorial')
    end

    def edit; end

    def update
      @tutorial.update!(params.require(:verification_tutorial).permit!)
      redirect_to edit_admin_verification_tutorial_path
    end
  end
end