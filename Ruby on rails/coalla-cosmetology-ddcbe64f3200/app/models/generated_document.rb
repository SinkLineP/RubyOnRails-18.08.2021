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

class GeneratedDocument < ActiveRecord::Base
  belongs_to :item, polymorphic: true

  validates :type, :created_on, :idx, :number, presence: true

  mount_uploader :user_file, PrivateFileUploader

  before_validation :set_defaults

  after_save do
    begin
      File.delete(path_was) if path_changed? && path_was
    rescue => ex
      Rails.logger.error("Couldn't delete file: #{path_was}. #{ex.message}")
    end
  end

  %W(AdditionOrder SubscriptionContract OrderContract PayerAgreement PracticeAgreement Questionnaire MultipleQuestionnaire ExpulsionOrder FinalWorkRegistry WorkingOffSheet).each do |klass|
    define_method("#{klass.underscore}?") do
      is_a?(klass.constantize)
    end
  end

  def self.new_idx(date)
    (where(year: date.year, type: name).maximum(:idx) || 0) + 1
  end

  def generated?
    path.present?
  end

  def new_idx
    self.class.new_idx(created_on) if created_on.present?
  end

  def user_filename
    user_file.try(:file).try(:filename)
  end

  def generate!(options = {})
    transaction do
      generate(options)
      save!
    end
  rescue PG::UniqueViolation
    self.number = nil
    retry
  end

  def generate(options = {})
    number_from_options = options.delete(:number)

    self.set_defaults
    self.number = number_from_options if number_from_options.present?

    builder = options[:without_marks] ? Documents::EmptyDocumentBuilder : Documents::DocumentBuilder

    self.path = builder.build(self.class.name, { item: item, number: number, date: created_on }.deep_merge(options))
    self.set_file_properties(options[:document_name])
  end

  def set_defaults
    self.created_on ||= Date.today
    self.year = created_on.try(:year)
    self.idx = new_idx if idx.blank? || created_on_changed?
    self.number = generate_number if number.blank? || created_on_changed?
  end

  def generate_number
    idx
  end

  def full_path
    if generated?
      "#{Rails.root}/#{path}"
    else
      self.path
    end
  end

  def set_file_properties(document_name = nil)
    self.file_name = document_name || File.basename(full_path)
    self.file_size = File.size(full_path).to_f
  end

  def destroy_file
    File.delete(full_path)
  rescue => ex
    Rails.logger.error("Couldn't delete file: #{full_path}. #{ex.message}")
  end

  def contract?
    nil
  end

  def certificate?
    nil
  end

  protected

  def remove_user_file
    if self.user_file?
      self.remove_user_file!
      self.user_file_status = 'user_file_not_loaded'
    end
  end
end
