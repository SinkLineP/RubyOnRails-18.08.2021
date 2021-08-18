class DefaultController < ActionController::Base
  def page_not_found
    @url = OldUrl.get_url!(request.original_fullpath)
    redirect_to @url, status: 301
  end
end