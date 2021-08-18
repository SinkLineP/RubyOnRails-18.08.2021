module GroupSubscriptions
  class AmoLead
    def initialize(params = {})
      @params = params
    end

    def create
      subscription = GroupSubscription.find_by(id: params[:subscription_id])
      return unless subscription
      student = subscription.student

      lead = Amocrm::Entities::Lead.new(lead_params(subscription))
      lead.status_id = subscription.created_from_module? ? subscription.amocrm_status.try(:amocrm_id) : subscription.shop.amocrm_primary_treatment_status.amocrm_id
      lead.pipeline_id = subscription.created_from_module? ? AmocrmPipeline.modules_pipeline.amocrm_id : subscription.shop.pipeline.amocrm_id
      lead.tags = "Заявка, #{subscription.course.tag_name}" unless subscription.created_from_module?
      lead.save!
      subscription.update_columns(amocrm_id: lead.id)

      contact = Amocrm::Entities::Contact.find(student.amocrm_id) if student.amocrm_id.present?
      unless contact
        contact = Amocrm::Entities::Contact.new(contact_params(student))
        contact.responsible_user_id = Amocrm::DEFAULT_MANAGER
        contact.save!
      end
      student.update_columns(amocrm_id: contact.id)

      begin
        retries ||= 0
        contact.reload
        contact.linked_leads_id += [lead.id]
        contact.last_modified = contact.actual_last_modified
        contact.save!
      rescue Amorail::Entity::InvalidRecord
        retry if (retries += 1) < 3
      end

      return if subscription.amocrm_status.try(:success?)
    end

    def update
      subscription = GroupSubscription.find_by(id: params[:subscription_id])
      return if subscription.try(:amocrm_id).blank?
      lead = Amocrm::Entities::Lead.find(subscription.amocrm_id)
      return unless lead
      lead.status_id = subscription.amocrm_status.try(:amocrm_id)
      params = lead_params(subscription)
      params[:last_modified] = lead.actual_last_modified
      lead.update!(params)
    end

    def destroy
      return if params[:amocrm_id].blank?
      lead = Amocrm::Entities::Lead.find(params[:amocrm_id])
      lead.update!(removed_from_sdo: true, last_modified: lead.actual_last_modified) if lead
    end

    private

    attr_reader :params

    def lead_params(subscription)
      {
        name: subscription.group_title,
        roistat: params[:roistat],
        roistat_marker: params[:roistat_marker],
        group_id: subscription.group_id,
        education_form_id: subscription.education_form_id,
        group_price_id: subscription.group_price_id,
        discount_id: subscription.discount_id,
        promotion_id: subscription.promotion_id,
        promotion_source: subscription.promotion_source,
        price: subscription.price,
        last_modified: Time.now.to_i
      }
    end

    def contact_params(student)
      {
        name: student.full_name,
        education_level_id: student.education_level_id,
        email: student.email,
        phone: student.phone,
        main: true
      }
    end
  end
end