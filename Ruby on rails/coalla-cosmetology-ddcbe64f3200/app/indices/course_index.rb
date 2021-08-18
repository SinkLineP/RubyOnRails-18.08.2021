ThinkingSphinx::Index.define :course, with: :active_record, delta: true do
  indexes :name
  indexes :title
  indexes :syllabus
  indexes :job
  indexes curriculum_blocks.title, as: :curriculum_block_titles
  indexes curriculum_blocks.content, as: :curriculum_block_contents
  indexes skills.name, as: :skill_names

  has :nearest_education_day
  has specialities.id, as: :speciality_ids
  has :active
  has :created_at
  has :id, as: :id_number
  has 'COALESCE(courses.shop_id, 0)', type: :integer, as: :shop_id
end