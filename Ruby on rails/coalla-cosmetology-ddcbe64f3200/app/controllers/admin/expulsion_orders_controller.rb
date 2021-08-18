# Логика приказов об отчислении
# @see app/views/admin/expulsion_orders
# @see app/views/admin/groups/_form.html.haml
module Admin
  class ExpulsionOrdersController < AdminController
    load_and_authorize_resource :group

    def show
      @group.expulsions.build(expelled_on: Date.current, expulsion_order_attributes: { created_on: Date.current })
      @group_expulsion_order = @group.expulsions.find_by(personal: false, non_attendance: false).try(:expulsion_order)
    end

    def update
      @group.assign_attributes(group_params)
      @group.save!
      redirect_to admin_group_expulsion_order_path(@group)
    end

    def refunds
      @expulsions = @group.expulsions.includes(:expelled_students, expelled_students: :student)
      @refunds = Refunds.new(@expulsions).calculate
      render :refunds, layout: false
    end

    protected

    def group_params
      params.require(:group).permit!
    end
  end
end