module Mindbox
  class AuthorizationOnWebsite < Operation
    def data
      user = @options[:user]
      return unless user
      {
        customer: {
          email: user.email
        }
      }
    end
  end
end