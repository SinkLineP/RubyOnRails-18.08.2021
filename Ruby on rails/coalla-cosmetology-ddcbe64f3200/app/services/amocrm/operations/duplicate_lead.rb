module Amocrm
  module Operations
    class DuplicateLead
      def initialize(lead_id, group_id)
        @lead_id = lead_id
        @group_id = group_id
      end

      def perform
        return if @lead_id.blank? || @group_id.blank?
        lead = Amocrm::Entities::Lead.find(@lead_id)
        fail!('Lead not found') unless lead
        group = ::Group.find_by(id: @group_id)
        fail!('Group not found') unless group
        return if ::AmocrmPipeline.sale_pipelines.exclude?(lead.pipeline_id.to_i) || lead.price.to_f.zero? || group.fake?
        lead_double = create_lead_double!(lead)
        link_lead_double!(lead, lead_double)
        create_task!(lead_double, group)
      rescue Amocrm::UnduplicatableSubscription => ex
        if Rails.env.production?
          Rails.logger.error("Unable to duplicate lead. #{ex.message}")
        else
          raise
        end
      end

      def failure(job)
        error = StandardError.new("Unable to create lead double. Job #{job.id}")
        error.set_backtrace(job.last_error)
        ::CustomExceptionNotifier.notify_exception(error)
      end

      private

      def fail!(message)
        raise Amocrm::UnduplicatableSubscription.new(message)
      end

      def create_lead_double!(lead)
        params = {
          name: "#{lead.name} ДОПРОДАЖА",
          pipeline_id: ::AmocrmPipeline::FOR_SALE,
          status_id: ::AmocrmStatus::FEEDBACK,
          last_modified: lead.actual_last_modified,
          tags: lead.tags_list.join(','),
          responsible_user_id: lead.responsible_user_id
        }
        lead = Amocrm::Entities::Lead.new(params)
        lead.save!
        lead
      end

      def link_lead_double!(lead, lead_double)
        contact = lead.contact
        contact.reload
        contact.linked_leads_id += [lead_double.id]
        contact.last_modified = contact.actual_last_modified
        contact.save!
        contact
      end

      def create_task!(lead_double, group)
        complete_till = calculate_complete_till(lead_double, group)
        task = Amorail::Task.new(text: "Допродажа #{lead_double.name}",
                                 complete_till: complete_till,
                                 element_id: lead_double.id,
                                 element_type: Amocrm::ElementType::LEAD,
                                 task_type: Amorail.properties.tasks['follow_up'].id,
                                 responsible_user_id: lead_double.responsible_user_id)
        task.save!
        task
      end

      def calculate_complete_till(lead_double, group)
        has_custom_tags = (lead_double.tags_list & ::Amocrm::CUSTOM_TAGS).present?
        period = has_custom_tags ? 1.month : 1.week
        first_practice = group.practices.first
        date = first_practice.try(&:end_date_time) || group.end_date_time
        date + period
      end
    end
  end
end