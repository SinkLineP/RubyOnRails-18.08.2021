class EnglishController < ApplicationController
  layout 'en'

  def index
    @en_page = EnPage.first
    redirect_to root_path if @en_page.title.blank? && @en_page.content.blank?
  end

end