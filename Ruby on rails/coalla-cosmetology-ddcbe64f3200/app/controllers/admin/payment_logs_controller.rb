# Управление платежами студента
# @see app/views/admin/payment_logs
# @see app/views/admin/students/_form.html.haml
# @see app/views/admin/students/_student.html.haml
module Admin
  class PaymentLogsController < AdminController
    before_action do
      @student = Student.find(params[:student_id])
    end

    load_and_authorize_resource :payment_log, through: :student

    def index
      @payment_logs = @student.payment_logs.ordered.paginate(page: params[:page] || 1, per_page: PER_PAGE)
    end

    def new
      @payment_log = @student.payment_logs.new
    end

    def create
      @payment_log = @student.payment_logs.new
      save_and_responce
    end

    def edit
    end

    def update
      save_and_responce
    end

    def destroy
      @payment_log.destroy!
      redirect_to admin_student_payment_logs_path(@student)
    end

    private

    def save_and_responce
      @payment_log.assign_attributes(payment_log_params)

      if @payment_log.save
        redirect_to edit_admin_student_payment_log_path(@student, @payment_log)
        return
      end

      render :edit
    end

    def payment_log_params
      params.require(:payment_log).permit!
    end
  end
end