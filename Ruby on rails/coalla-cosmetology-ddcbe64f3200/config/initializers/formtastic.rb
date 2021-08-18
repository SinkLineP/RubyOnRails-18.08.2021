# encoding: utf-8

# Set the default text field size when input is a string. Default is nil.
# Formtastic::FormBuilder.default_text_field_size = 50

# Set the default text area height when input is a text. Default is 20.
# Formtastic::FormBuilder.default_text_area_height = 5

# Set the default text area width when input is a text. Default is nil.
# Formtastic::FormBuilder.default_text_area_width = 50

# Should all fields be considered "required" by default?
# Defaults to true.
# Formtastic::FormBuilder.all_fields_required_by_default = true

# Should select fields have a blank option/prompt by default?
# Defaults to true.
# Formtastic::FormBuilder.include_blank_for_select_by_default = true

# Set the string that will be appended to the labels/fieldsets which are required.
# It accepts string or procs and the default is a localized version of
# '<abbr title="required">*</abbr>'. In other words, if you configure formtastic.required
# in your locale, it will replace the abbr title properly. But if you don't want to use
# abbr tag, you can simply give a string as below.
# Formtastic::FormBuilder.required_string = "(required)"

# Set the string that will be appended to the labels/fieldsets which are optional.
# Defaults to an empty string ("") and also accepts procs (see required_string above).
# Formtastic::FormBuilder.optional_string = "(optional)"

# Set the way inline errors will be displayed.
# Defaults to :sentence, valid options are :sentence, :list, :first and :none
# Formtastic::FormBuilder.inline_errors = :sentence
# Formtastic uses the following classes as default for hints, inline_errors and error list

# If you override the class here, please ensure to override it in your stylesheets as well.
# Formtastic::FormBuilder.default_hint_class = "inline-hints"
# Formtastic::FormBuilder.default_inline_error_class = "inline-errors"
# Formtastic::FormBuilder.default_error_list_class = "errors"

# Set the method to call on label text to transform or format it for human-friendly
# reading when formtastic is used without object. Defaults to :humanize.
# Formtastic::FormBuilder.label_str_method = :humanize

# Set the array of methods to try calling on parent objects in :select and :radio inputs
# for the text inside each @<option>@ tag or alongside each radio @<input>@. The first method
# that is found on the object will be used.
# Defaults to ["to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]
# Formtastic::FormBuilder.collection_label_methods = [
#   "to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]

# Specifies if labels/hints for input fields automatically be looked up using I18n.
# Default value: true. Overridden for specific fields by setting value to true,
# i.e. :label => true, or :hint => true (or opposite depending on initialized value)
# Formtastic::FormBuilder.i18n_lookups_by_default = false

# Specifies if I18n lookups of the default I18n Localizer should be cached to improve performance.
# Defaults to true.
# Formtastic::FormBuilder.i18n_cache_lookups = false

# Specifies the class to use for localization lookups. You can create your own
# class and use it instead by subclassing Formtastic::Localizer (which is the default).
# Formtastic::FormBuilder.i18n_localizer = MyOwnLocalizer

# You can add custom inputs or override parts of Formtastic by subclassing Formtastic::FormBuilder and
# specifying that class here.  Defaults to Formtastic::FormBuilder.
# Formtastic::Helpers::FormHelper.builder = MyCustomBuilder

# All formtastic forms have a class that indicates that they are just that. You
# can change it to any class you want.
# Formtastic::Helpers::FormHelper.default_form_class = 'formtastic'

# Formtastic will infer a class name from the model, array, string or symbol you pass to the
# form builder. You can customize the way that class is presented by overriding
# this proc.
# Formtastic::Helpers::FormHelper.default_form_model_class_proc = proc { |model_class_name| model_class_name }

# Allows to set a custom field_error_proc wrapper. By default this wrapper
# is disabled since `formtastic` already adds an error class to the LI tag
# containing the input.
# Formtastic::Helpers::FormHelper.formtastic_field_error_proc = proc { |html_tag, instance_tag| html_tag }

# You can opt-in to Formtastic's use of the HTML5 `required` attribute on `<input>`, `<select>`
# and `<textarea>` tags by setting this to true (defaults to false).
# Formtastic::FormBuilder.use_required_attribute = false

# You can opt-in to new HTML5 browser validations (for things like email and url inputs) by setting
# this to true. Doing so will omit the `novalidate` attribute from the `<form>` tag.
# See http://diveintohtml5.org/forms.html#validation for more info.
# Formtastic::FormBuilder.perform_browser_validations = true

# By creating custom input class finder, you can change how input classes  are looked up.
# For example you can make it to search for TextInputFilter instead of TextInput.
# See # TODO: add link # for more information
# NOTE: this behavior will be default from Formtastic 4.0
Formtastic::FormBuilder.input_class_finder = Formtastic::InputClassFinder

# Define custom namespaces in which to look up your Input classes. Default is
# to look up in the global scope and in Formtastic::Inputs.
# Formtastic::FormBuilder.input_namespaces = [ ::Object, ::MyInputsModule, ::Formtastic::Inputs ]

# By creating custom action class finder, you can change how action classes are looked up.
# For example you can make it to search for MyButtonAction instead of ButtonAction.
# See # TODO: add link # for more information
# NOTE: this behavior will be default from Formtastic 4.0
Formtastic::FormBuilder.action_class_finder = Formtastic::ActionClassFinder

# Define custom namespaces in which to look up your Action classes. Default is
# to look up in the global scope and in Formtastic::Actions.
# Formtastic::FormBuilder.action_namespaces = [ ::Object, ::MyActionsModule, ::Formtastic::Actions ]

# Which columns to skip when automatically rendering a form without any fields specified.
# Formtastic::FormBuilder.skipped_columns = [:created_at, :updated_at, :created_on, :updated_on, :lock_version, :version]

module Formtastic
  module Inputs
    module Base
      def input_wrapping(&block)
        html = super
        template.concat(html) if template.output_buffer && template.assigns[:has_many_block]
        html
      end
    end
  end
end

module Coalla
  class FormBuilder < ::Formtastic::FormBuilder

    self.input_namespaces = [::Object, ::Formtastic::Inputs]

    # TODO: remove both class finders after formtastic 4 (where it will be default)
    self.input_class_finder = ::Formtastic::InputClassFinder
    self.action_class_finder = ::Formtastic::ActionClassFinder

    def cancel_link(url = { action: "index" }, html_options = {}, li_attrs = {})
      li_attrs[:class] ||= "cancel"
      li_content = template.link_to "Отменить", url, html_options
      template.content_tag(:li, li_content, li_attrs)
    end

    attr_accessor :already_in_an_inputs_block

    def has_many(assoc, options = {}, &block)
      HasManyBuilder.new(self, assoc, options).render(&block)
    end
  end

  # Decorates a FormBuilder with the additional attributes and methods
  # to build a has_many block.  Nested has_many blocks are handled by
  # nested decorators.
  class HasManyBuilder < SimpleDelegator
    attr_reader :assoc
    attr_reader :options
    attr_reader :heading, :sortable_column, :sortable_start
    attr_reader :new_record, :destroy_option

    def initialize(has_many_form, assoc, options)
      super has_many_form
      @assoc = assoc
      @options = extract_custom_settings!(options.dup)
      @options.reverse_merge!(for: assoc)
      @options[:class] = [options[:class], "inputs has_many_fields"].compact.join(' ')
      @btn_add = @options[:btn_add]
      if sortable_column
        @options[:for] = [assoc, sorted_children(sortable_column)]
      end
    end

    def render(&block)
      html = "".html_safe
      html << template.content_tag(:h3) { heading } if heading.present?
      html << template.capture { content_has_many(&block) }
      html = wrap_div_or_li(html)
      template.concat(html) if template.output_buffer
      html
    end

    protected

    # remove options that should not render as attributes
    def extract_custom_settings!(options)
      @heading = options.key?(:heading) ? options.delete(:heading) : default_heading
      @sortable_column = options.delete(:sortable)
      @sortable_start = options.delete(:sortable_start) || 0
      @new_record = options.key?(:new_record) ? options.delete(:new_record) : true
      @destroy_option = options.delete(:allow_destroy)
      options
    end

    def default_heading
      ""
    end

    def assoc_klass
      @assoc_klass ||= __getobj__.object.class.reflect_on_association(assoc).klass
    end

    def content_has_many(&block)
      form_block = proc do |form_builder|
        render_has_many_form(form_builder, options[:parent], &block)
      end

      template.assigns[:has_many_block] = true
      contents = without_wrapper { inputs(options, &form_block) }
      contents ||= "".html_safe

      js = new_record ? js_for_has_many(options[:class], &form_block) : ''
      contents << js
    end

    # Renders the Formtastic inputs then appends delete and sort actions.
    def render_has_many_form(form_builder, parent, &block)
      index = parent && form_builder.send(:parent_child_index, parent)
      template.concat template.capture { yield(form_builder, index) }
      template.concat has_many_actions(form_builder, "".html_safe)
    end

    def has_many_actions(form_builder, contents)
      if form_builder.object.new_record?
        # contents << template.content_tag(:li) do
        #   template.link_to 'Удалить', "#", class: 'button has_many_remove'
        # end
      elsif allow_destroy?(form_builder.object)
        form_builder.input(:_destroy, as: :boolean,
                                      wrapper_html: { class: 'has_many_delete' },
                                      label: 'Удалить')
      end

      if sortable_column
        form_builder.input sortable_column, as: :hidden

        contents << template.content_tag(:li, class: 'handle') do
          ""
        end
      end

      contents
    end

    def allow_destroy?(form_object)
      !! case destroy_option
         when Symbol, String
           form_object.public_send destroy_option
         when Proc
           destroy_option.call form_object
         else
           destroy_option
         end
    end

    def sorted_children(column)
      __getobj__.object.public_send(assoc).sort_by do |o|
        attribute = o.public_send column
        [attribute.nil? ? Float::INFINITY : attribute, o.id || Float::INFINITY]
      end
    end

    def without_wrapper
      is_being_wrapped = already_in_an_inputs_block
      self.already_in_an_inputs_block = false

      html = yield

      self.already_in_an_inputs_block = is_being_wrapped
      html
    end

    # Capture the ADD JS
    def js_for_has_many(class_string, &form_block)
      @btn_add ||= "Добавить"
      assoc_name = assoc_klass.model_name
      placeholder = "NEW_#{assoc_name.to_s.underscore.upcase.gsub(/\//, '_')}_RECORD"
      opts = {
        for: [assoc, assoc_klass.new],
        class: class_string,
        for_options: { child_index: placeholder }
      }
      html = template.capture { __getobj__.send(:inputs_for_nested_attributes, opts, &form_block) }
      text = new_record.is_a?(String) ? new_record : "<div class='icon_add'>+</div> #{@btn_add}".html_safe
      doc = Nokogiri::HTML(html)
      html = doc.search('fieldset.inputs.has_many_fields').tap{ |ns| ns.add_class('new_record') }.to_html
      template.link_to text, '#', class: "button has_many_add", data: {
        html: CGI.escapeHTML(html).html_safe, placeholder: placeholder
      }
    end

    def wrap_div_or_li(html)
      template.content_tag(already_in_an_inputs_block ? :li : :div,
                           html,
                           class: "has_many_container #{assoc}",
                           'data-sortable' => sortable_column,
                           'data-sortable-start' => sortable_start)
    end
  end
end

Formtastic::Inputs::Base::Labelling.module_eval do

  def label_html_options
    {
      :for => input_html_options[:id],
      :class => (['label'] + (options[:label_class] || [])).flatten
    }
  end
end