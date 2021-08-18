class FeedbacksController < ApplicationController

  def create
    feedback = OpenStruct.new(feedback_params)
    Delayed::Job.enqueue(Amocrm::Operations::CreateTasks.new(3779901,
                                                             User.find_by(email: feedback.email).try(:amocrm_id),
                                                             nil, nil, feedback.email, nil,
                                                             "СДО. ОБРАТНОЯ СВЯЗЬ. #{feedback.message}"),
                         queue: :amocrm)
    redirect_to :message_sent_feedbacks
  end

  def message_sent
  end

  private
    def feedback_params
      params.require(:feedback).permit!
    end
end
