module UserActivityRecordable

  def record_activity
    gon.activity = {
        title: "Лекция #{@lecture.lecture_index}",
        description: @lecture.description,
        trackable_id: @lecture.id,
        trackable_type: 'Lecture'
    }
  end

end