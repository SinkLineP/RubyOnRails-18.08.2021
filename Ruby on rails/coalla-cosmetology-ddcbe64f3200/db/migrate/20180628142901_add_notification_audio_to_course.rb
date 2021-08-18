class AddNotificationAudioToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :notification_audio, :text
    add_column :courses, :ivr_audio, :text
  end
end
