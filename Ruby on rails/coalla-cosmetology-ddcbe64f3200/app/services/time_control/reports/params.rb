module TimeControl
  module Reports
    class Params
      include ActiveAttr::BasicModel
      include ActiveAttr::Attributes
      include ActiveAttr::MassAssignment
      include ActiveAttr::TypecastedAttributes

      attribute :begin_on, type: Date
      attribute :end_on, type: Date
      attribute :user_id
      attribute :email

      with_options presence: true do
        validates :begin_on, :end_on
        validates :email, format: { with: Devise.email_regexp }
      end

      def user
        return if user_id.blank?
        @user ||= ::User.find(user_id)
      end

      def users_emails
        if user
          [user.email]
        else
          []
        end
      end

      def as_json
        super['attributes'].merge('users_emails' => users_emails)
      end
    end
  end
end