# Контроллер раздела "Руководитель"
# @see AbstractLookupsController
# @see app/views/admin/abstract_lookups
module Admin
  class AboutLookupsController < AbstractLookupsController

    protected

    def scope_name
      'about'
    end

  end
end