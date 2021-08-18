class AddConfiguratorPositionToLookup < ActiveRecord::Migration
  def change
    Lookup.create!(type_code: 'string', code: 'configurator', value: '1')
  end
end
