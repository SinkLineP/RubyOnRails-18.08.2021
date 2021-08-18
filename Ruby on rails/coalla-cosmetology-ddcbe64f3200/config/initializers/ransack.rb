Ransack.configure do |config|
  config.add_predicate 'boolean_equals',
                       arel_predicate: 'eq',
                       formatter: proc { |v| v == 'NULL' ? nil : v },
                       type: :string
end