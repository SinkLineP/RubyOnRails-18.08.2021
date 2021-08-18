ThinkingSphinx::Index.define :book, with: :active_record, delta: true do
  indexes :author
  indexes :name
  indexes :description
  has :created_at
end