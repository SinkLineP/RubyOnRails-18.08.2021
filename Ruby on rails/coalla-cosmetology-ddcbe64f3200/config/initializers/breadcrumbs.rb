BreadcrumbsOnRails::Breadcrumbs::Element.class_eval do
  def initialize(name, path = nil, options = {})
    self.name     = name.is_a?(Symbol) ? I18n.t("breadcrumbs.#{name}") : name
    self.path     = path
    self.options  = options
  end
end
