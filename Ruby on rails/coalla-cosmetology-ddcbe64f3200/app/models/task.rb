# == Schema Information
#
# Table name: tasks
#
#  id                 :integer          not null, primary key
#  type               :text
#  title              :text
#  description        :text
#  answer             :text
#  lecture_id         :integer
#  max_answer_length  :integer
#  max_attempts_count :integer
#  time_limit         :integer
#  items_count        :integer
#  created_at         :datetime
#  updated_at         :datetime
#  final              :boolean          default(FALSE), not null
#
# Indexes
#
#  index_tasks_on_lecture_id  (lecture_id)
#


class Task < ActiveRecord::Base
  include DeepDup

  belongs_to :lecture, inverse_of: :task
  has_one :block, through: :lecture

  has_many :columns, -> { order(:position) }, inverse_of: :task, dependent: :destroy
  accepts_nested_attributes_for :columns, reject_if: ->(attributes){ attributes[:title].blank? }

  has_many :questions, -> { order(:position) }, inverse_of: :task, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :results, dependent: :destroy

  def columns_attributes=(columns_attributes)
    columns_attributes ||= []
    super
  end

  def questions_attributes=(questions_attributes)
    questions_attributes ||= []
    questions.each do |question|
      unless questions_attributes.any? { |questions_attributes| questions_attributes[:id] == question.id }
        questions_attributes << {
            id: question.id,
            '_destroy' => true
        }
      end
    end
    super
  end

  def test?
    is_a?(TestTask)
  end

  def file?
    is_a?(FileTask)
  end

  def type_name
    @type_name ||= type.gsub('Task', '')
  end

  def new_result_model(options = {})
    user = options.delete(:user)
    result_model = "Result#{type_name}".constantize
    result_model.new(task: self, student: user)
  end

  def display_name
    I18n.t("tasks.#{type.underscore}")
  end

  def deep_dup
    super(associations: [:questions, :columns])
  end

  def editable
    results.blank?
  end
end
