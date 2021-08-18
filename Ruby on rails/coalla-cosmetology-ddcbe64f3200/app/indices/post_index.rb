ThinkingSphinx::Index.define :post, with: :active_record, delta: true do
  indexes :title
  indexes :announcement
  indexes :text
  has :created_at
  has 'COALESCE(shop_id, 0)', type: :integer, as: :shop_id
end