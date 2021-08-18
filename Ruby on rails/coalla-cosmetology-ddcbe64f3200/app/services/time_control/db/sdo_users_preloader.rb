module TimeControl
  module Db
    class SdoUsersPreloader
      def initialize(items)
        @items = items
      end

      def preload
        emails = @items.map { |event| event.uemail }.compact.map(&:downcase)
        if emails.blank?
          @items.each { |item| item.sdo_user = nil }
          return
        end
        sdo_users = ::User.preload(:groups).where(type: %w(Instructor Student), email: emails) +
          ::User.where.not(type: %w(Instructor Student)).where(email: emails)
        @items.each do |item|
          item.sdo_user = sdo_users.detect { |sdo_user| sdo_user.email == item.uemail }
        end
      end
    end
  end
end