module SimpleActsAsList
  extend ActiveSupport::Concern

  module ClassMethods
    def simple_acts_as_list(scope: nil)
      scope = "#{scope}_id" if scope.is_a?(Symbol) && scope.to_s !~ /_id$/

      before_create :add_to_list

      define_method :scope_condition do
        scope ? { :"#{scope}" => send(scope) } : {}
      end

      define_method 'set_list_position' do |position|
        self.position = position
        save(validate: false)
      end

    end
  end

  private

  def add_to_list
    self.position = bottom_position_in_list + 1
  end

  def bottom_position_in_list
    self.class.unscoped do
      self.class.where(scope_condition).order(position: :desc).pluck(:position).first.to_i
    end
  end


end