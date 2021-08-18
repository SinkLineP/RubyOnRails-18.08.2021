module TimeControl
  module Db
    class Event < BaseRecord
      self.table_name = 'graph_fact_events'
      self.primary_key = 'regid'

      belongs_to :user, foreign_key: :uid
      belongs_to :door, foreign_key: :doorid

      delegate :uemail, to: :user, allow_nil: true

      ransacker :regdatefull, type: :date do
        Arel.sql('CAST(regdatefull AS date)')
      end

      def sdo_user=(value)
        @sdo_user_preloaded = true
        @sdo_user = value
      end

      def sdo_user
        return @sdo_user if @sdo_user_preloaded || !(user && user.uemail.presence)
        @sdo_user_preloaded = true
        @sdo_user = ::User.find_by(email: user.uemail)
      end
    end
  end
end