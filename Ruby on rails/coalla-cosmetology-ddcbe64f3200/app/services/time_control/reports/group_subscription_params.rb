module TimeControl
  module Reports
    class GroupSubscriptionParams
      include ActiveAttr::BasicModel
      include ActiveAttr::Attributes
      include ActiveAttr::MassAssignment

      attr_accessor :group_subscription
      attribute :email

      delegate :group, to: :group_subscription
      delegate :student, to: :group_subscription

      validates :email, presence: true, format: { with: Devise.email_regexp }

      def users_emails
        [student.email]
      end

      def as_json
        super['attributes'].merge('users_emails' => users_emails,
                                  'begin_on' => group.nearest_education_day,
                                  'end_on' => group.last_education_day)
      end
    end
  end
end