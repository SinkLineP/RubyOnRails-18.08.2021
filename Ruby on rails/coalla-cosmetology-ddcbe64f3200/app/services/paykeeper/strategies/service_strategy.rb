module Paykeeper
  module Strategies
    class ServiceStrategy < BaseStrategy
      protected

      def load_data
        @student = Student.find_by(email: @params[:client_email])
        unless @student
          CosmetologyMailer.failed_payment(@params).deliver!
          logger.error("Student with email #{@params[:client_email]} not found!")
          return false
        end

        group = Group.find_by(title: @params[:service_name])
        if group
          @group_subscription = @student.group_subscriptions.find_by(group_id: group.id)
          logger.error("Group subscription for Student(id=#{@student.id}) and Group(id=#{group.id}) not found!") unless @group_subscription
        else
          logger.error("Group with title #{@params[:service_name]} not found!")
        end
        true
      end

      def receipt_params
        { item: @group_subscription } if @group_subscription
      end

      def apply_payment!
        if @group_subscription
          create_subscription_payment!
        else
          create_extraordinary_payment!
          CosmetologyMailer.extraordinary_payment(@student, @params).deliver!
        end
      end

      def create_subscription_payment!
        log = PaymentLog.create!(payment_type: :site,
                                 payed_on: Date.current,
                                 appointment: :education,
                                 group_id: @group_subscription.group_id,
                                 amount: @params[:sum].to_f,
                                 student_id: @group_subscription.student_id)
        logger.info("Payment Log (id=#{log.id}) for Subscription(id=#{log.id}) created.")
      end

      def create_extraordinary_payment!
        log = PaymentLog.create!(payment_type: :site,
                                 payed_on: Date.current,
                                 appointment: :extraordinary,
                                 comment: 'Платёж из Paykeeper',
                                 amount: @params[:sum].to_f,
                                 student_id: @student.id)
        logger.info("Payment Log (id=#{log.id}) created.")
      end
    end
  end
end