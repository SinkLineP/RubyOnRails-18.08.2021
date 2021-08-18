class SharedModels
  CLASSES = [
    AboutImage,
    Article,
    Banner,
    SquareBanner,
    Block,
    BlogCategory,
    Category,
    Course,
    CurriculumBlock,
    Faculty,
    Faq,
    Graduate,
    Group,
    GroupSubscription,
    HistoryEvent,
    HtmlItem,
    Instructor,
    Lookup,
    Order,
    Partner,
    Post,
    Promotion,
    Recall,
    SiteMetaTags,
    Speciality,
    CosmetologyProcedure
  ]

  class << self
    def with_shop(shop_id)
      set_current_shop(shop_id)
      result = yield
      unset_current_shop
      result
    rescue
      unset_current_shop
      raise
    end

    def set_current_shop(shop_id)
      CLASSES.each { |_class| set_current_shop_for_model(_class, shop_id) }
      true
    end

    def set_current_shop_for_model(model, shop_id)
      model.class_eval do
        define_method :set_default_shop do
          assign_attributes(shop_id: shop_id) if shop_id.present?
        end

        default_scopes.delete_if { |scope| scope.source_location[0].include?('shared_models') }
        default_scope { where(shop_id: shop_id) }

        before_validation :set_default_shop
      end

      true
    end

    def unset_current_shop
      CLASSES.each { |_class| unset_current_shop_for_model(_class) }
      true
    end

    def unset_current_shop_for_model(model)
      model.class_eval do
        remove_method(:set_default_shop) if method_defined?(:set_default_shop)
        default_scopes.delete_if { |scope| scope.source_location[0].include?('shared_models') }
        skip_callback(:validation, :before, :set_default_shop)
      end

      true
    end

  end
end