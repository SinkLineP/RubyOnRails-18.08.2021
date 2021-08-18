# Контроллер раздела "Ссылки на соц.сети"
# @see AbstractLookupsController
module Admin
  class SocialLookupsController < AbstractLookupsController
    protected

    def scope_name
      'socials'
    end
  end
end