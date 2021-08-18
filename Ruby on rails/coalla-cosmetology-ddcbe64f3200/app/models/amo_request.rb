# == Schema Information
#
# Table name: amo_requests
#
#  id         :integer          not null, primary key
#  method     :string           not null
#  url        :text             not null
#  params     :text             not null
#  timeout    :float            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_amo_requests_on_created_at  (created_at)
#

class AmoRequest < ActiveRecord::Base
  TIMEOUT = 1.seconds

  class << self
    def lock_table
      connection.execute("LOCK TABLE #{table_name} IN ACCESS EXCLUSIVE MODE")
    end

    def timeout
      time_current = Time.current
      last_request_at = AmoRequest.maximum(:created_at) || time_current - TIMEOUT
      since_last_request = time_current - last_request_at
      result = (TIMEOUT - since_last_request).round(1)
      [result, 0].max
    end
  end

  validates :method, :url, :params, presence: true
end
