module CoursesShop
  class OldUrlsController < BaseController

    def show
      new_url = OldUrl.get_url(request.path)
      if new_url
        redirect_to new_url, status: 301
        return
      end
    end
  end
end