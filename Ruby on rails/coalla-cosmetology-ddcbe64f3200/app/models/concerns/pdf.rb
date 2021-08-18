module Pdf
  extend ActiveSupport::Concern

  included do
    enumerize :pdf_status, in: [:in_progress, :completed, :failed]

    has_many :pdf_images, -> { order(:position) }, as: :imagable, dependent: :destroy

    attr_accessor :skip_job, :pdf_assigned

    mount_uploader :pdf, PdfUploader

    after_save :regenerate_pdf_images, if: :generate_pdf_images?

    def generate_pdf_images?
      !skip_job && pdf_assigned
    end

    def pdf_cache=(value)
      return if value.blank?
      super(value)
      pdf_will_change!
      self.pdf_assigned = true
    end

    def pdf_extension
      pdf.try(:file).try(:extension).try(:upcase)
    end

    def pdf_filename
      pdf.try(:file).try(:filename)
    end

    def regenerate_pdf_images
      pdf_images.destroy_all
      update_column(:pdf_status, nil)
      perform_create_pdf_images if pdf.present?
    end

    def create_pdf_images
      transaction do
        pdf_images.destroy_all

        PdfConverter.new(pdf).each_image_file do |image_file, idx|
          if idx == 0
            update!(preview: image_file) if respond_to?(:preview)
            update!(cover: image_file) if respond_to?(:cover)
          end
          pdf_images.create!(image: image_file, position: idx)
          idx
        end
      end
      update_column(:pdf_status, :completed)
    rescue => ex
      pdf_processing_failed(ex)
    end

    def pdf_processing_failed(exception)
      update_columns(pdf_status: :failed, pdf: nil)
      pdf_images.destroy_all
      CustomExceptionNotifier.notify_exception(exception) unless Rails.env.development?
    end

    def perform_create_pdf_images
      update_column(:pdf_status, :in_progress)
      Delayed::Job.enqueue CreatePdfImages.new(id, self.class.name)
    end

    def pdf_editable
      pdf_status.blank? || %w(completed failed).include?(pdf_status.to_s)
    end

    def pdf_present?
      pdf.present? && pdf_editable
    end
  end
end