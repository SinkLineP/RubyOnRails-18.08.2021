# Логика для приказов о зачислении
# @see app/views/admin/addition_orders
# @see app/views/admin/groups/_form.html.haml
module Admin
  class AdditionOrdersController < AdminController
    load_and_authorize_resource :group

    def show
      @addition_order = @group.addition_order || @group.build_addition_order(created_on: Date.today)
      @addition_order.assign_attributes(number: @addition_order.generate_number)
    end

    def update
      @group.assign_attributes(group_params)
      @group.save_and_generate_documents!
      redirect_to admin_group_addition_order_path(@group)
    end

    protected

    def group_params
      params.require(:group).permit!
    end
  end
end