module Wordpress
  class Import
    class << self
      def notify
        new.notify
      end

      def run
        ThinkingSphinx::Deltas.suspend(:user) do
          new.run
        end
      end
    end

    def notify
      ::User.where.not(wordpress_id: nil).find_each do |user|
        password = generate_password
        user.update!(password: password)
        CoursesShop::CoursesShopMailer.new_password(user, password).deliver!
        user.update_columns(welcome_sent_at: Time.current)
      end
    end

    def run
      Wordpress::User.each do |wp_user|
        email = wp_user.user_email.downcase

        next if ::User.where(type: %w(Administrator Manager Instructor), email: email).any?

        site_user = Student.find_or_initialize_by(email: email)

        if site_user.new_record?
          site_user.assign_attributes(phones: [wp_user.user_phone],
                                      wordpress_id: wp_user.id,
                                      full_name: wp_user.user_names,
                                      password: generate_password)
        end

        wp_user.socials_data.each do |social_data|
          provider = social_data.provider.downcase
          next if site_user.authentications.find_by(provider: provider)
          site_user.authentications.build(provider: provider,
                                          uid: social_data.identifier,
                                          access_token: social_data.object_sha,
                                          url: social_data.profileurl)
        end

        site_user.save!
      end

      nil
    end

    private

    def generate_password
      Devise.friendly_token(8)
    end
  end
end