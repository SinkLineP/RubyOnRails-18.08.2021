module CoursesShop
  module BussinesHelper
    def units_text(unit)
      {
          rub: "руб.",
          rub_per_meter: "руб./м<sup>2</sup>",
          rub_per_month: "руб./мес"
      }[unit.to_sym].html_safe
    end
  end
end