# frozen_string_literal: true

# Модуль с общими методами для загрузчиков
# Содержит генерацию уникальных имен, работу с размерами и т.п.
module ImageUploaderUtils
  include Piet::CarrierWaveExtension
  extend ActiveSupport::Concern

  included do
    # Оптимизация
    process convert: 'jpg'
    process optimize: [{quality: 65, level: 6, verbose: true}] if Rails.env.production? || Rails.env.staging?
  end

  # Возвращает сгенерированное имя для новых файлов
  # и уже имеющееся - для загруженных
  # @return [String] имя файла
  def filename
    @name ||= if original_filename.present?
                "#{timestamp}.jpg"
              else
                model.read_attribute(mounted_as)
              end
  end

  # Возвращает временную отметку в милисекундах
  # @return [String] временная отметка
  def timestamp
    var = :"@#{mounted_as}_timestamp"
    if model
      model.instance_variable_get(var) || model.instance_variable_set(var, (Time.now.to_f * 1000).to_i)
    else
      instance_variable_get(var) || instance_variable_set(var, (Time.now.to_f * 1000).to_i)
    end
  end

  # Список разрешенных расширений
  # @return [Array<String>] расширения
  def extension_white_list
    %w[jpg jpeg png gif tiff]
  end
end
