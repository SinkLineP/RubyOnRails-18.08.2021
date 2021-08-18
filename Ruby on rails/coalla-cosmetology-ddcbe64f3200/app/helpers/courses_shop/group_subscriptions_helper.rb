module CoursesShop
  module GroupSubscriptionsHelper
    def education_form_options(group, selected_form = nil)
      return '' unless group
      education_forms = [EducationForm.offline, EducationForm.online].map do |form|
        free_places = group.free_places_for(form)
        [form, places_text(free_places)] if free_places > 0
      end.reject(&:blank?).to_h
      options_for_select(education_forms.map { |form, count| ["#{t("education_form.#{form.form_type}")} (#{group.fake ? '—' : count})".html_safe, form.id] }, selected_form.try(:id))
    end
  end
end