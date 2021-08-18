# == Schema Information
#
# Table name: works
#
#  id                     :integer          not null, primary key
#  title                  :text
#  appendix               :text
#  type                   :text
#  form_sheet             :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  criterion              :text
#  duration               :integer          default(0), not null
#  break_days             :integer          default(0), not null
#  hairdresser_form_sheet :text
#  statement_criterion    :text
#

class Work < ActiveRecord::Base
  extend Enumerize

  COMMON_CRITERIONS = [:not_selected]
  COSMETIC_CRITERIONS = [:purification, :eyebrows_painting, :face_massage, :masks, :depilation, :makeup, :shaping_nails, :manicure, :hairdresser]
  BARBER_CRITERIONS = [:classic_long_shape, :mens_fingers_haircut, :classic_square_shape, :classic_mens_haircut, :fade_haircut, :final_work, :highlighting, :coloring, :texturing, :women_haircut, :lightening, :highlighting_advanced_level]

  enumerize :form_sheet, in: [:simple, :f_3_5, :f_3_6, :f_3_7, :f_3_8, :f_3_9, :f_3_3_3_1, :f_0_9]
  enumerize :hairdresser_form_sheet, in: [:f_2_5, :f_2_6, :f_2_7, :f_2_8, :f_2_9, :f_2_10, :f_2_11, :f_2_12]
  enumerize :criterion, in: COMMON_CRITERIONS + COSMETIC_CRITERIONS, default: COMMON_CRITERIONS.first
  enumerize :statement_criterion, in: COMMON_CRITERIONS + BARBER_CRITERIONS, default: COMMON_CRITERIONS.first, predicates: { prefix: true }

  has_many :exercises, -> { order(:index) }, dependent: :destroy, inverse_of: :work
  has_one :work_result, -> { order(:created_at) }, dependent: :destroy, inverse_of: :work
  has_many :course_works, dependent: :destroy, inverse_of: :work
  has_many :working_off_lists, dependent: :nullify, inverse_of: :work
  has_many :work_classrooms, dependent: :destroy, inverse_of: :work
  has_many :instructor_works, dependent: :destroy, inverse_of: :work
  has_many :schedule_items, dependent: :destroy, inverse_of: :work

  accepts_nested_attributes_for :exercises, allow_destroy: true

  scope :order_by_title, -> { order(:title) }

  before_validation do
    self.form_sheet = nil if ladder? || final_work?
  end

  with_options presence: true do
    validates :title
    validates :duration,
              numericality: {
                allow_blank: true,
                greater_than_or_equal_to: 0,
                only_integer: true
              }
  end


  def with_exercises?
   ( (exam? || practice_work?) && form_sheet != :simple ) || hairdresser_work?
  end

  def with_sub_exercises?
    with_exercises? && form_sheet == :f_3_3_3_1
  end

  def with_sheet_columns?
    form_sheet != hairdresser_work? ? true : :f_0_9 && !with_sub_exercises?
  end

  def exam?
    is_a?(Exam)
  end

  def ladder?
    is_a?(Ladder)
  end

  def practice_work?
    is_a?(PracticeWork)
  end

  def final_work?
    is_a?(FinalWork)
  end

  def hairdresser_work?
    is_a?(HairdresserWork)
  end

  def human_name
    self.class.model_name.human
  end

  def full_title
    [appendix, title].reject(&:blank?).join(' ')
  end

  def build_exercises
    return exercises if exercises.present?
    return unless with_exercises?

    unless with_sub_exercises?
      exercises_count.times { |i| exercises.build(index: i + 1) }
      return exercises
    end

    3.times do |i|
      parent_exercise = exercises.build(index: i + 1)
      3.times { |j| parent_exercise.exercises.build(parent: parent_exercise, index: j + 1) }
    end
    exercises.build(index: 4)

    exercises
  end

  def common_form_sheet
    send("#{hairdresser_work?.presence && 'hairdresser_'}form_sheet")
  end


  def exercises_count
    return 0 unless with_exercises?

    if with_sub_exercises?
      return 4
    end
    common_form_sheet.to_s.gsub(/._._/, '').to_i
  end
end
