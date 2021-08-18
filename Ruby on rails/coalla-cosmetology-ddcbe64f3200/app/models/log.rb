# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id              :integer          not null, primary key
#  editor_id       :integer
#  action_type     :integer
#  description     :text
#  loggerable_id   :integer
#  loggerable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_logs_on_loggerable_type_and_loggerable_id  (loggerable_type,loggerable_id)
#

class Log < ActiveRecord::Base
  belongs_to :loggerable, polymorphic: true
  belongs_to :editor, class_name: "User", foreign_key: "editor_id"
  enum action_type: %i[updated created merged deleted]
  default_scope { order(created_at: :desc) }
  def full_name
    editor.display_name
  end

  def email
    editor.email
  end
end
