require 'csv'
class StudentReport
  include ApplicationHelper
  include UserActivityHelper

  def initialize(email)
    @user = User.find_by!(email: email)
  end

  def build
    activities = @user.user_activities.unscope(:order).order(:created_at)


    CSV.open(File.join(Rails.root, "activity_#{@user.email}.csv"), 'wb') do |csv|
      csv << ['Наименование', 'Описание', 'Затраченное время', 'Дата']

      activities.find_each do |activity|
        title = activity.trackable.try(:title) != activity.title ? "#{activity.title} #{activity.trackable.try(:title)}" : activity.title
        csv << [title, activity.description, display_activity_spent_time(activity), display_activity_date(activity)]
      end
    end
  end
end