if @student
  json.editUrl edit_admin_student_url(@student)
end

json.educationLevels @education_levels do |level|
  json.id level.id
  json.title level.title
end

json.documents @student.try(:document_copies) || [] do |document_copy|
  json.file document_copy.file.try(:url)
  json.fileName document_copy.file.try(:file).try(:filename)
end