# Контроллер раздела "Презентация"
# @see app/views/admin/tutorial/
module Admin
  class TutorialController < AdminController
    set_current_shop_for_model(Lookup)

    before_action do
      authorize! :manage, :tutorial
      @tutorial = Lookup.find_by(code: 'tutorial')
    end

    def edit; end

    def update
      @tutorial.update!(params.require(:tutorial).permit!)
      redirect_to edit_admin_tutorial_path
    end
  end
end