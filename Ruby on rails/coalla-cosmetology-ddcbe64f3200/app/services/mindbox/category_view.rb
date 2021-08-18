module Mindbox
  class CategoryView < Operation
    def data
      speciality = @options[:speciality]
      return unless speciality
      {
        productCategory: {
          ids: {
            website: speciality.id
          }
        }
      }
    end
  end
end