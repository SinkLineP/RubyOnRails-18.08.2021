ThinkingSphinx::Index.define :block, with: :active_record, delta: true do
  indexes :name
  has :created_at
  has 'COALESCE(shop_id, 0)', type: :integer, as: :shop_id
end