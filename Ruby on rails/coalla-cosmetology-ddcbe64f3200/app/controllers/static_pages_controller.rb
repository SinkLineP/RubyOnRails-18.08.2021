class StaticPagesController < ApplicationController

  layout 'application'

  def show
    @static_page = StaticPage.find(params[:id])
    set_title(['Дом Русской Косметики', @static_page.title.mb_chars.capitalize])
    render @static_page.permanent? ? params[:id] : :show
  end

end