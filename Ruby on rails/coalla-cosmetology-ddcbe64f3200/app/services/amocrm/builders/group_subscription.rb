# frozen_string_literal: true

module Amocrm
  module Builders
    class GroupSubscription < Item
      def create_or_update!
        check_lead_is_not_removed!
        check_lead_is_skip_sdo!

        group = load_group!
        student_ids = load_students!

        items = find_or_initialize_subscriptions(group, student_ids)

        items.each do |item|
          unprocessable_data!("Subscription with id=#{item.id} deleted") if item.deleted?
          check_lead_is_not_auto_and_wsr!(item)

          check_data_actuality!(item)

          tags_was = item.amocrm_tags

          assign_group_info(item, group)
          assign_subscription_info(item)
          assign_amo_info(item)
          assign_shop(item)

          item.calculate_payments if (item.discount_id_changed? || item.group_price_id_changed?) && !item.group_id_changed?

          notify = item.status_changed_to_success?
          status_changed_notify = item.success? && !item.amocrm_status_id_changed? && (@amocrm_entity.tags_list - tags_was).present?

          check_item_validity!(item)

          item.save_and_generate_documents!
          next if ::AmocrmPipeline.resuscitation.include?(@amocrm_entity.pipeline_id.to_i)
          Notifications::StatusChanged.new(@amocrm_entity).notify if status_changed_notify && !item.expired?
          GroupSubscriptions::Notifier.new(item).notify! if notify
        end

        items
      end

      private

      def check_lead_is_skip_sdo!
        return if @amocrm_entity.pipeline_id.to_i != 3153186
        unprocessable_data!("Leads with id 3153186 skip on SDO.")
      end

      def check_lead_is_not_removed!
        return if @amocrm_entity.removed_from_sdo != "1"
        unprocessable_data!("Lead removed from SDO.")
      end

      def check_lead_is_not_auto_and_wsr!(item)
        if ["K-WSR", "PU-WSR", "UT-WSR", "UL-WSR-Med", "UL-WSR-BM", "M-WSR", "WSR-MOBIR"].include?(Group.find_by(id: @amocrm_entity.group_id).course.short_name)
          return if item.amocrm_id == @amocrm_entity.id
          unprocessable_data!("WSR AutoLead #{@amocrm_entity.id}. Skip on SDO.")
        end
      end

      def load_group!
        group = Group.find_by(id: @amocrm_entity.group_id)
        return group if group

        unprocessable_data!("Couldn't find Group with id=#{@amocrm_entity.group_id}")
      end

      def load_students!
        contact = @amocrm_entity.contact
        unprocessable_data!("Lead has no contacts") if contact.blank?
        students = ::Student.where(amocrm_id: contact.id)
        return students if students.present?
        unprocessable_data!("Couldn't find Student with amocrm_id=#{contact.id}")
      end

      def find_or_initialize_subscriptions(group, students)
        subscription_scope = ::GroupSubscription.with_deleted
        students.map do |student|
          subscription = subscription_scope.find_by(group: group, student_id: student) || subscription_scope.find_or_initialize_by(amocrm_id: @amocrm_entity.id)
          subscription.student = student
          subscription
        end.sort_by { |subscription| subscription.updated_at.to_i }
      end

      def assign_group_info(item, group)
        item.group_id = group.id
        if item.group_id_changed? || item.begin_on.blank?
          item.begin_on = group.begin_on
          item.end_on = group.end_on
        end
      end

      def assign_subscription_info(item)
        item.assign_attributes(amocrm_status: AmocrmStatus.find_by(amocrm_id: @amocrm_entity.status_id),
                               discount: Discount.find_by(id: @amocrm_entity.discount_id),
                               promotion: Promotion.find_by(id: @amocrm_entity.promotion_id),
                               promotion_source: @amocrm_entity.promotion_source,
                               education_form: EducationForm.find_by(id: @amocrm_entity.education_form_id),
                               group_price: GroupPrice.find_by(id: @amocrm_entity.group_price_id),
                               amo_module: AmoModule.find_by(id: @amocrm_entity.amo_module_id))
      end

      def assign_amo_info(item)
        item.assign_attributes(amocrm_id: @amocrm_entity.id,
                               responsible_name: load_responsible_user.try(:[], "name"),
                               amocrm_tags: @amocrm_entity.tags_list,
                               imported_from_amo: item.new_record?)
      end

      def assign_shop(item)
        item.shop = ::AmocrmPipeline.find_by(amocrm_id: @amocrm_entity.pipeline_id).try(:shop) || ::Shop.default_shop
      end

      def load_responsible_user
        Amorail.properties.data["users"].detect { |user| user["id"] == @amocrm_entity.responsible_user_id.to_s }
      end
    end
  end
end
