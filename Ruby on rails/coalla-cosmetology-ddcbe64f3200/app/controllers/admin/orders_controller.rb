# Управление заказами студента
# @see app/views/admin/orders
# @see app/views/admin/students/_form.html.haml
# @see app/views/admin/students/_student.html.haml
module Admin
  class OrdersController < AdminController
    before_action do
      @student = Student.find(params[:student_id])
    end

    load_and_authorize_resource :order, through: :student

    def index
      @orders = @student.orders.in_cart.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @order = @student.orders.new
    end

    def edit; end

    def create
      @order.assign_attributes(order_params.merge!(cart: true))
      if @order.save
        redirect_to admin_student_orders_path(@student)
        return
      end
      render :new
    end

    def update
      @order.assign_attributes(order_params)
      render :edit
    end

    def destroy
      @order.destroy
      redirect_to admin_student_orders_path(@student)
    end

    private

    def order_params
      params.require(:order).permit!.tap do |h|
        h[:group_subscription_ids] ||= []
      end
    end
  end
end