module FirstPageRedirectable
  extend ActiveSupport::Concern

  included do 
    before_action :redirect_without_page, if: Proc.new { params[:page] == '1'}
  end

  def redirect_without_page
    redirect_to action: params[:action], params: params.except(:controller, :action, :page), status: :moved_permanently
  end

  private :redirect_without_page

end