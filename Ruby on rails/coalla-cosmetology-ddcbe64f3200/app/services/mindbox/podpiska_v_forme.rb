module Mindbox
  class PodpiskaVForme < Operation
    def data
      blog_subscriber = @options[:blog_subscriber]
      return unless blog_subscriber
      {
        customer: {
          email: blog_subscriber.email,
          subscriptions: [
            {
              pointOfContact: 'Email',
              isSubscribed: true,
              valueByDefault: false
            }]
        }
      }
    end
  end
end