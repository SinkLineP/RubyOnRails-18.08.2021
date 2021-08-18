module Mindbox
  class ProductView < Operation
    def data
      course = @options[:course]
      return unless course
      {
        product: {
          ids: {
            website: course.id
          }
        }
      }
    end
  end
end