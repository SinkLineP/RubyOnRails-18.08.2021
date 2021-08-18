class CourseConfigurator
  include ActiveAttr::BasicModel
  include ActiveAttr::Attributes
  include ActiveAttr::MassAssignment
  include ActiveAttr::AttributeDefaults
  include ActiveAttr::TypecastedAttributes

  attribute :education_period, type: Integer, default: 6
  attribute :subject
  attribute :medical_education, type: Boolean
  attribute :work_in_cosmetology, type: Boolean

  def subject=(value)
    return if !value.is_a?(Array)
    filtered = value.select { |v| Course.subject.values.include?(v) }
    super(filtered)
  end

  def filtered_courses
    scope = Course.joins(:course_specialities).displayed.where(medical_education: medical_education).uniq
    result = scope.where('education_period <= ?', education_period)
    result = result.where(work_in_cosmetology: work_in_cosmetology)
    result = result.where(subject_conditions) if subject_conditions

    if result.count == 0
      result = scope
      result = result.where(subject_conditions) if subject_conditions
    end

    if result.count == 0
      result = scope
    end

    result
  end

  def subject_conditions
    return unless subject

    subject.map { |s| "subject like '%#{s}%'" }.join(' OR ')
  end
end