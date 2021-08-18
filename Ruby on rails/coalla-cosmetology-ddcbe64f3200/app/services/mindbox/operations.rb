module Mindbox
  class Operations
    def initialize(options = {})
      @options = options
    end

    class << self
      def operation_parameters(operation, options = {})
        new(options).send(operation)
      end
    end

    %w(product_view category_view set_cart_item_list create_ordervia_one_click registration_on_website podpiska_v_forme edit_user_data all_promo_view authorization_on_website).each do |operation|
      define_method operation do
        "Mindbox::#{operation.camelize}".constantize.new(@options).to_js
      end
    end
  end
end