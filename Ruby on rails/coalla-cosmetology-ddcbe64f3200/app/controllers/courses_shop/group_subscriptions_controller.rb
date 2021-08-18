module CoursesShop
  class GroupSubscriptionsController < BaseController
    include AjaxRequestsOnly

    layout false, except: :show

    before_action :authenticate_user!
    before_action :ajax_requests_only, except: :show

    def show
      @group_subscription = current_user.group_subscriptions
                              .created_not_actual_ordered
                              .find(params[:id])
      course = @group_subscription.course
      @similars = course.similars.with_specialities.ordered.paginate(page: (params[:page].presence || 1).to_i,
                                                                     per_page: PER_PAGE)
      if request.xhr?
        render_ajax_collection(@similars, 'courses_shop/courses/course_li', '#similar_courses_list', false)
        return
      end
    end

    def new
      @course = Course.find(params[:course_id])
      group = @course.find_nearest_group(params[:group_id]) || @course.nearest_groups.first
      education_form = group.academics_free_place > 0 ? EducationForm.offline : EducationForm.online
      @group_subscription = current_user.group_subscriptions.build(group: group,
                                                                   begin_on: group.begin_on,
                                                                   end_on: group.end_on,
                                                                   education_form: education_form)
      @group_info = Groups::SubscriptionInfo.new(@group_subscription)
    end

    def create
      new_subscription_params = group_subscription_params.merge(amocrm_status: current_shop.amocrm_primary_treatment_status,
                                                                created_by_user: true)
      subscription = current_user.group_subscriptions.build(new_subscription_params)
      if subscription.save
        GroupSubscriptions::AmoLeadActionJob.enqueue(:create, subscription_id: subscription.id, roistat: cookies[:roistat_visit], roistat_marker: cookies[:roistat_marker])
        render json: { location: courses_shop_cart_path, mindbox: mindbox_order_parameters, fbEvent: ('fbAddToCart' if current_shop.barbershop?) }
      else
        render json: { errors: subscription.errors }
      end
    end

    def edit
      @group_subscription = current_user.group_subscriptions.find(params[:id])
      @group_info = Groups::SubscriptionInfo.new(@group_subscription)
      @course = @group_subscription.course
    end

    def update
      subscription = current_user.group_subscriptions.find(params[:id])
      subscription.assign_attributes(group_subscription_params)
      subscription.calculate_payments
      if subscription.save
        render json: { location: courses_shop_cart_path, mindbox: mindbox_order_parameters }
      else
        render json: { errors: subscription.errors }
      end
    end

    def destroy
      subscription = current_user.group_subscriptions.find(params[:id])
      subscription.destroy_without_paranoia
      GroupSubscriptions::AmoLeadActionJob.enqueue(:destroy, amocrm_id: subscription.amocrm_id)
      render json: { location: courses_shop_cart_path, mindbox: mindbox_order_parameters }
    end

    private

    def group_subscription_params
      params.require(:group_subscription).permit(:group_id,
                                                 :begin_on,
                                                 :end_on,
                                                 :education_form_id,
                                                 :group_price_id)
    end

    def mindbox_order_parameters
      current_user.reload
      order = current_user.orders.new(cart: true)
      order.group_subscription_ids = current_user.cart_subscriptions.map(&:id)
      Orders::PaymentsCalculator.new(order).recalculate
      Mindbox::Operations.operation_parameters(:set_cart_item_list, order: order)
    end

  end
end
