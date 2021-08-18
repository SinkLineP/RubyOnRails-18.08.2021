# Комментарии к результатам
# @see app/views/admin/my_students/_result_comment.haml
module Admin
  class ResultCommentsController < AdminController
    load_and_authorize_resource :result

    def update
      @result.update!(comment: params[:comment]) if params[:comment].present?
      render nothing: true
    end

    def notify
      CosmetologyMailer.result_comment(@result).deliver!
      render nothing: true
    end

  end
end