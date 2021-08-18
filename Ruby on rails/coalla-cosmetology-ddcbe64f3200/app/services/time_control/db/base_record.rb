module TimeControl
  module Db
    class BaseRecord < ActiveRecord::Base
      establish_connection YAML.load_file(Rails.root.join('config', 'database.yml').to_s)['time_control']

      self.abstract_class = true
    end
  end
end