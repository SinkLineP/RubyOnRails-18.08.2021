module GroupSubscriptions
  class ModuleGroupsBuilder
    def initialize(group_subscription)
      @group_subscription = group_subscription
      @student = @group_subscription.student
    end

    def build!
      unless @group_subscription.amo_module
        @group_subscription.module_groups.destroy_all
        return
      end
      @group_subscription.transaction do
        module_groups = recreate_module_groups!
        module_groups.each { |module_group| create_or_update_subscription!(module_group) }
      end
    end

    private

    def create_or_update_subscription!(module_group)
      return if subscription_with_group_exists?(module_group)
      if module_group.module_subscription
        update_subscription!(module_group)
      elsif !module_group.module_subscription && @group_subscription.success?
        create_subscription!(module_group)
      end
    end

    def create_subscription!(module_group)
      return unless module_group.group
      group = module_group.group
      module_group.create_module_subscription!(group: group,
                                               begin_on: group.begin_on,
                                               end_on: group.end_on,
                                               education_form: EducationForm.online,
                                               amocrm_status: AmocrmStatus.success,
                                               student: @group_subscription.student,
                                               created_from_module: true,
                                               module_group: module_group)
    end

    def update_subscription!(module_group)
      module_subscription = module_group.module_subscription
      module_subscription.amocrm_status = @group_subscription.success? ? AmocrmStatus.success : AmocrmPipeline.modules_primary_treatment_status
      module_subscription.save!
    end

    def subscription_with_group_exists?(module_group)
      !module_group.module_subscription &&
        @student.all_group_subscriptions.joins(:group).where('groups.course_id = ?', module_group.course_id).exists?
    end

    def recreate_module_groups!
      courses = @group_subscription.amo_module.courses
      amo_module = @group_subscription.amo_module
      @group_subscription.module_groups = courses.map do |course|
        @group_subscription.module_groups.find_or_initialize_by(course_id: course.id, amo_module_id: amo_module.id).tap do |module_group|
          module_group.group = course.groups.detect(&:fake?) || course.nearest_groups.first || course.groups.active.order(end_on: :desc).last if module_group.new_record? || !module_group.group
          module_group.save!
        end
      end
    end
  end
end