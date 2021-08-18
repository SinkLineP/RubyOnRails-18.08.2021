module WithFriendly
  extend ActiveSupport::Concern

  class_methods do
    def find_by_friendly(param)
      if param.to_i.to_s == param
        find_by(id: param) || find_by(slug: param)
      else
        find_by(slug: param)
      end
    end

    def find_by_friendly!(param)
      if param.to_i.to_s == param
        find_by(id: param) || find_by!(slug: param)
      else
        find_by!(slug: param)
      end
    end
  end
end
