# == Schema Information
#
# Table name: lectures
#
#  id                   :integer          not null, primary key
#  description          :text
#  time                 :integer
#  block_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  lecture_link         :text
#  video_link           :text
#  position             :integer
#  term                 :integer
#  pdf                  :text
#  pdf_status           :text
#  read_before_practice :boolean          default(FALSE), not null
#
# Indexes
#
#  index_lectures_on_block_id  (block_id)
#  index_lectures_on_position  (position)
#

class Lecture < ActiveRecord::Base
  extend Enumerize
  include WithUploadedVideo
  include DeepDup
  include Pdf

  FILTERED_ATTRIBUTES = %w(task_editable pdf_filename pdf_extension pdf_editable)

  simple_acts_as_list scope: :block

  belongs_to :block, inverse_of: :lectures
  has_many :feedback_questions, inverse_of: :lecture, dependent: :nullify
  has_many :courses, through: :block
  has_many :results, through: :task
  has_many :personal_notices, inverse_of: :lecture, dependent: :destroy
  has_many :course_works, dependent: :nullify, inverse_of: :lecture

  has_many :materials, -> { order(type: :desc, position: :asc) }, inverse_of: :lecture, dependent: :destroy
  accepts_nested_attributes_for :materials, allow_destroy: true

  has_many :downloads, -> { order(:position) }, inverse_of: :lecture, dependent: :destroy
  accepts_nested_attributes_for :downloads, allow_destroy: true

  has_one :task, inverse_of: :lecture, dependent: :destroy
  accepts_nested_attributes_for :task

  with_uploaded_video

  delegate :editable, to: :task, allow_nil: true, prefix: true

  alias_attribute :title, :description

  after_create :add_notice

  def lecture_index
    position
  end

  def to_backbone
    as_json(only: %i(id description time term video_link lecture_link position read_before_practice),
            methods: %i(task_editable pdf_extension pdf_filename task_editable pdf_editable uploaded_video_id),
            include: {
              materials: { only: %i(id name time link required type), methods: %i(cover_file_url cover_file_name cover_cache pdf_filename pdf_editable) },
              downloads: { only: %i(id), methods: %i(url filename extension cache) },
              task: {
                only: %i(id type title description answer max_answer_length max_attempts_count items_count time_limit final),
                include: {
                  columns: {
                    only: %i(id title),
                    include: {
                      column_variants: {
                        only: %i(id title)
                      }
                    }
                  },
                  questions: {
                    only: %i(id title image),
                    methods: %i(image_name),
                    include: {
                      question_answers: {
                        only: %i(id title)
                      }
                    }
                  }
                }
              }
            })
  end

  def materials_attributes=(materials_attributes)
    materials_attributes ||= []
    materials.each do |material|
      unless materials_attributes.any? { |materials_attributes| materials_attributes[:id] == material.id }
        materials_attributes << {
          id: material.id,
          '_destroy' => true
        }
      end
    end
    super
  end

  def downloads_attributes=(downloads_attributes)
    downloads_attributes ||= []
    downloads.each do |download|
      unless downloads_attributes.any? { |downloads_attributes| downloads_attributes[:id] == download.id }
        downloads_attributes << {
          id: download.id,
          '_destroy' => true
        }
      end
    end
    super
  end

  def deep_dup
    self.skip_job = true
    super(associations: [:materials, :downloads, :task, { item_video: :item_id }, { pdf_images: :imagable_id }], files: [:pdf])
  end

  def editable
    results.blank?
  end

  def previous_block_lecture
    block.lectures.where('position <  ?', position).last
  end

  def video?
    return true if video_link.present?
  end

  private

  def add_notice
    task = previous_block_lecture.try(:task)
    return if task.blank?

    students_for_notification_ids = Result.where(task: task, passed: true).pluck(:student_id).uniq

    transaction do
      students_for_notification_ids.each do |student_id|
        PersonalNotice.create!(student_id: student_id, lecture_id: id, message: 'Уважаемый учащийся. Мы&nbsp;добавили в&nbsp;систему новую лекцию и&nbsp;новое задание. Система автоматически переместила вас к&nbsp;этому новому материалу. Пожалуйста, прочитайте лекцию, сдайте задание, и&nbsp;вам снова откроется доступ ко&nbsp;всем уже изученным лекциям. Спасибо!')
      end
    end
  end


end
