module Mindbox
  class RegistrationOnWebsite < Operation
    def data
      user = @options[:user]
      return unless user
      {
        customer: {
          ids: {
            userwebsiteid: user.id,
          },
          firstName: user.first_name,
          middleName: user.middle_name,
          mobilePhone: user.phone,
          email: user.email,
          subscriptions: [
            {
              pointOfContact: 'Email',
              isSubscribed: user.subscribed_on_blog,
              valueByDefault: false
            }
          ]
        }
      }
    end
  end
end