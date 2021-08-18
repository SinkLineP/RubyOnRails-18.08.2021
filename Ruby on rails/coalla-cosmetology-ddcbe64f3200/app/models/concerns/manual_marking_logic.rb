module ManualMarkingLogic
  PASSING_SCORE = 60

  def max_mark
    100
  end

  def manual_marking?
    true
  end

  protected

  def call_marking_logic(options={})
    mark = options.delete(:mark)
    instructor = options.delete(:instructor)

    if mark.blank?
      self.status = :on_mark
      return
    end

    mark = mark.to_i

    correct_mark = [mark, 100].min if mark > 0
    correct_mark = [mark, 0].max if mark <= 0

    assign_attributes(mark: correct_mark, status: :marked, passed: (correct_mark >= PASSING_SCORE), instructor: instructor)
    user_activities.last.update_column(:description, description_for_activity) if user_activities.present?
  end

end