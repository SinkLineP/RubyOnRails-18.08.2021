# == Schema Information
#
# Table name: generated_documents
#
#  id         :integer          not null, primary key
#  path       :text
#  type       :text
#  file_name  :text
#  file_size  :float
#  idx        :integer
#  number     :text
#  year       :integer
#  created_on :date
#  item_id    :integer
#  item_type  :string
#  user_file  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  with_print :boolean          default(FALSE), not null
#
# Indexes
#
#  index_generated_documents_on_idx                    (idx)
#  index_generated_documents_on_item_type_and_item_id  (item_type,item_id)
#

class GroupList < GeneratedDocument
end
