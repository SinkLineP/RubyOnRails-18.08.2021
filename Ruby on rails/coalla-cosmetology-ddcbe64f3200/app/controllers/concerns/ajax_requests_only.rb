module AjaxRequestsOnly
  def ajax_requests_only
    redirect_to(request.referer || root_path) unless request.xhr?
  end
end