module Wordpress
  class User
    class << self
      def client
        @client ||= Mysql2::Client.new(YAML::load(File.read(Rails.root.join('config', 'import.yml'))))
      end

      def query(sql)
        client.query(sql, symbolize_keys: true)
      end

      def each
        query('SELECT id, user_email FROM wp_users WHERE spam = 0 AND deleted = 0').each do |result|
          # load id and user_email
          user = OpenStruct.new(result.to_h)

          # load user_names and user_phone
          user_info = query("SELECT meta_key, meta_value FROM wp_usermeta WHERE user_id = #{result[:id]} AND meta_key IN ('user_names', 'user_phone')")
          user_info.each do |info|
            key = info[:meta_key]
            value = info[:meta_value]
            user[key] = value
          end

          # load social's data
          socials_data = query("SELECT provider, object_sha, identifier, profileurl FROM wp_wslusersprofiles WHERE user_id = #{result[:id]} AND provider IN('Vkontakte', 'Facebook')")
          user.socials_data = socials_data.map{|data| OpenStruct.new(data.to_h)}

          yield(user)
        end
      end
    end
  end
end