module TimeFields
  extend ActiveSupport::Concern

  class_methods do
    def formatted_time_field(*args)
      args.each do |time_field|
        define_method "formatted_#{time_field}" do
          Russian.strftime(self[time_field], '%H:%M') if self[time_field]
        end
      end
    end
  end

end