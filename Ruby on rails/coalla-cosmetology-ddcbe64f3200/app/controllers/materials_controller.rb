class MaterialsController < ApplicationController
  before_action do
    @course = Course.find(params[:course_id])
    @lecture = Lecture.find(params[:lecture_id])
    authorize! :show, @lecture, course: @course
  end

  def show
    @material = PdfMaterial.find(params[:id])
  end

  def mark_as_finished
    material = Material.find(params[:id])
    current_user.mark_material_as_finished!(material)
    render nothing: :true
  end
end