module Mindbox
  module Xml
    class FirstEmail
      def initialize(data)
        @data = data
      end

      def build
        builder = Builder::XmlMarkup.new
        builder.operation do
          builder.customer do
            builder.email @data[:email]
            builder.subscriptions do
              builder.subscription do
                builder.brand 'Cosmeticru'
                builder.pointOfContact 'Email'
                builder.isSubscribed true
              end
            end
          end
          builder.emailMailing do
            builder.customParameters do
              builder.login @data[:email]
              builder.password @data[:password]
            end
          end
        end
      end
    end
  end
end