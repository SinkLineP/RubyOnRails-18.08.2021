ThinkingSphinx::Index.define :user, with: :active_record, delta: true do
  indexes :email
  indexes :emails
  indexes :phones
  indexes :first_name
  indexes :last_name
  has :created_at
  has 'COALESCE(shop_id, 0)', type: :integer, as: :shop_id
end