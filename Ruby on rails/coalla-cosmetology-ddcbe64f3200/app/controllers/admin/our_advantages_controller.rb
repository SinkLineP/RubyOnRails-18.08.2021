# Контроллер раздела "Наши преимущества"
# @see app/views/admin/our_advantages
module Admin
  class OurAdvantagesController < AdminController
    before_action only: [:edit, :update] do
      @advantage = Lookup.our_advantages.find(params[:id])
      force_update_current_shop_id(@advantage.shop_id)
      authorize! :manage, @advantage
    end

    set_current_shop_for_model(Lookup)

    before_action only: :index do
      authorize! :read, Advantage
    end

    def index
      @our_advantages = Lookup.our_advantages.ordered
    end

    def edit
      render layout: false
    end

    def update
      @advantage.assign_attributes(params.require(:advantage).permit!)
      if @advantage.save
        render json: { redirect_url: url_for(action: :index) }
      else
        render json: { errors: @advantage.errors }
      end
    end
  end
end