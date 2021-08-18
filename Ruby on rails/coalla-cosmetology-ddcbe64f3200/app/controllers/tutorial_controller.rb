class TutorialController < ApplicationController
  before_action do
    authorize! :show, :tutorial
    @tutorial = Lookup.find_by(code: 'tutorial')
  end

  def hide
    current_user.hide_tutorial! if params[:hide_tutorial]
    redirect_to progress_path
  end
end