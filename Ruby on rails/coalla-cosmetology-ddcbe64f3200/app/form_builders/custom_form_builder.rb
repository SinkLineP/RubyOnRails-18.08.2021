class CustomFormBuilder < ActionView::Helpers::FormBuilder
  %w(email_field number_field password_field phone_field text_area text_field hidden_field select).each do |method_name|
    define_method "#{method_name}_with_validation" do |object_method, options|
      field_with_validation(method_name, object_method, options)
    end
  end

  def select_wrapped(object_method, choices, placeholder, html_options = {})
    html_options = {class: 'selectordie'}.merge(errors_options(object_method)).merge(html_options)
    select(object_method, [[placeholder, nil]] + choices, {}, html_options)
  end

  def base_errors
    errors = load_errors(:base)
    if errors.present?
      @template.content_tag('div', errors, class: 'alert mt-4')
    end
  end

  private

  def field_with_validation(helper_method, object_method, options = {})
    options = options.deep_merge(errors_options(object_method))
    send(helper_method, object_method, options).html_safe
  end

  def load_errors(object_method)
    (object.try(:errors).try(:[], object_method) || []).join(",\s")
  end

  def errors_options(object_method)
    errors = load_errors(object_method)
    if errors.present?
      {data: {valid: !errors.present?, errors: errors}}
    else
      {}
    end
  end
end