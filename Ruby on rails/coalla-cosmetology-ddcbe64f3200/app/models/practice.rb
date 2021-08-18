# == Schema Information
#
# Table name: practices
#
#  id         :integer          not null, primary key
#  begin_on   :date             not null
#  end_on     :date
#  start_time :time             not null
#  end_time   :time             not null
#  group_id   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_practices_on_group_id  (group_id)
#

class Practice < ActiveRecord::Base
  include TimeFields

  belongs_to :group, inverse_of: :practices

  formatted_time_field :start_time, :end_time

  with_options(presence: true) do
    validates :begin_on
    validates :start_time
    validates :end_time
    validates :group
    validates :end_on
  end
  validate :correctness_of_dates, if: -> { begin_on.present? && end_on.present?}

  def end_date_time
    DateTime.new(end_on.year, end_on.month, end_on.day, end_time.hour, end_time.min)
  end

  def date_of_end
    end_on || begin_on
  end

  def one_day?
    begin_on == end_on
  end

  private

  def correctness_of_dates
    errors.add(:correctness_of_dates, I18n.t('activerecord.errors.messages.dates_incorrect')) if begin_on > end_on
  end
end
