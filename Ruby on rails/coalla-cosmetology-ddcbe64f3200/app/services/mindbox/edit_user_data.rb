module Mindbox
  class EditUserData < Operation
    def data
      user = @options[:user]
      return unless user
      {
        customer: {
          authenticationTicket: AuthenticationToken.generate('UserWebSiteId', user.id),
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
              isSubscribed: user.subscribed_on_blog
            }
          ]
        }
      }
    end
  end
end
