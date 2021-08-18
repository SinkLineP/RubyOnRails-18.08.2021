# == Schema Information
#
# Table name: used_times
#
#  id              :integer          not null, primary key
#  date            :date
#  time            :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  consultation_id :integer
#
# Indexes
#
#  index_used_times_on_consultation_id  (consultation_id)
#  index_used_times_on_date             (date)
#  index_used_times_on_date_and_time    (date,time) UNIQUE
#

class UsedTime < ActiveRecord::Base
  include TimeFields

  SCHEDULE_STEP = 1.hour
  DEFAULT_START_TIME = Time.parse('2000-01-01 09:00 UTC')
  DEFAULT_END_TIME = Time.parse('2000-01-01 19:00 UTC')

  belongs_to :consultation, inverse_of: :used_time

  validates_presence_of :date
  validate :validate_uniqueness

  formatted_time_field :time

  scope :ordered, -> { order(date: :desc) }

  def self.possible_times(date)
    return [] unless date

    used_times = UsedTime.where(date: date)

    return [] if used_times.any? { |t| t.time.nil? }

    schedule_times.select do |time|
      used_times.none? { |used_time| used_time.time == time }
    end
  end

  def self.schedule_times
    (DEFAULT_START_TIME.to_i..DEFAULT_END_TIME.to_i)
        .step(SCHEDULE_STEP)
        .to_a
        .map { |time| Time.at(time).utc }
  end

  def self.can_use_all_day?(date, used_time = nil)
    return false unless date
    used_times = UsedTime.where(date: date)
    used_times = used_times.where.not(id: used_time.id) if used_time
    !used_times.any?
  end

  private

  def validate_uniqueness
    return unless date

    used_times = UsedTime.where(date: date)
    used_times = used_times.where.not(id: id) if persisted?

    if used_times.any? && time.nil?
      errors.add(:date, :taken)
      return
    end

    errors.add(:time, :taken) if used_times.any? { |t| t.time.nil? } || used_times.any? { |t| t.time == time }
  end
end
