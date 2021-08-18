ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'amocrm'
Dir['./spec/support/**/*.rb'].sort.each { |f| require(f) }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include CommonHelpers
  config.include AmoHelpers

  config.before(:suite) do
    Shop.create!(title: 'Дом Русской Косметики', code: :cosmetic)
    Shop.create!(title: 'Парикмахерская Академия', code: :barbershop)

    [
      {
        'id' => 279892,
        'title' => 'Отдельная воронка',
        'statuses' => [
          { 'id' => 11990269, 'title' => 'Первичное обращение' },
          { 'id' => 11990272, 'title' => 'Следующее касание' },
          { 'id' => 11990275, 'title' => 'Встреча' },
          { 'id' => 11990278, 'title' => 'Планирование оплаты' },
          { 'id' => 14558649, 'title' => 'Условный отказ' },
          { 'id' => 15678654, 'title' => 'Дубль' }
        ]
      },
      {
        'id' => 15591,
        'title' => 'Воронка',
        'statuses' => [
          { 'id' => 8391787, 'title' => 'Первичное обращение' },
          { 'id' => 8391790, 'title' => 'Может быть купять' },
          { 'id' => 8391793, 'title' => 'Теплые' },
          { 'id' => 9007842, 'title' => 'Агенты' },
          { 'id' => 11937384, 'title' => 'Встречи' }
        ]
      },
      {
        'id' => 589968,
        'title' => 'Воронка Допродаж',
        'statuses' => [
          { 'id' => 14787777, 'title' => 'Получить фидбэк' },
          { 'id' => 14787780, 'title' => 'Выбор курса' },
          { 'id' => 14787783, 'title' => 'Встреча' },
          { 'id' => 17366091, 'title' => 'Планирование оплаты' },
          { 'id' => 17366094, 'title' => 'Условный отказ' }
        ]
      },
      {
        'id' => 872490,
        'title' => 'Нулевая воронка',
        'statuses' => [
          { 'id' => 17394444, 'title' => 'Первичный контакт' },
        ]
      },
      {
        'id' => 1019854,
        'title' => 'Парикмахеры',
        'statuses' => [
          { 'id' => 18661498, 'title' => 'Первичный контакт' },
          { 'id' => 18661501, 'title' => 'Следующее касание' },
          { 'id' => 18661504, 'title' => 'Встреча' },
          { 'id' => 18661513, 'title' => 'Планирование оплаты' },
          { 'id' => 18661516, 'title' => 'Условный отказ' },
        ]
      },
      {
        'id' => 1349100,
        'shop_id' => Shop.cosmetic.id,
        'title' => 'Первичная воронка Косметология',
        'statuses' => [
          { 'id' => 21650958, 'title' => 'Лид получен', status_action: :primary_treatment },
          { 'id' => 21650961, 'title' => 'Квалифицирован клиент' },
          { 'id' => 21651168, 'title' => 'Предложение отправлено' },
          { 'id' => 21650964, 'title' => 'Возражение отработано 1' },
          { 'id' => 21651171, 'title' => 'Возражение отработано 2' },
          { 'id' => 21651174, 'title' => 'Сделано специальное преложение' },
          { 'id' => 21651177, 'title' => 'Получена догоовренность о встрече', status_action: :meeting },
          { 'id' => 21651180, 'title' => 'Встреча подтверждена' },
          { 'id' => 21651183, 'title' => 'Встреча проведена' },
          { 'id' => 21651186, 'title' => 'Дожим 1: специальное предложение' },
          { 'id' => 21651189, 'title' => 'Дожим 2 и более' },
          { 'id' => 21651192, 'title' => 'Получена договоренность о финальной встрече' },
          { 'id' => 21651195, 'title' => 'Финальная встреча подтверждена' },
          { 'id' => 21651198, 'title' => 'Финальная встреча проведена' },
          { 'id' => 21651201, 'title' => 'Оплата определена' }
        ]
      },
      {
        'id' => 1355847,
        'shop_id' => Shop.barbershop.id,
        'title' => 'Воронка Продаж Парикмахеры',
        'statuses' => [
          { 'id' => 21710913, 'title' => 'Лид получен', status_action: :primary_treatment },
          { 'id' => 21711111, 'title' => 'Квалифицирован клиент' },
          { 'id' => 21711114, 'title' => 'Предложение отправлено' },
          { 'id' => 21711117, 'title' => 'Возражение отработано 1' },
          { 'id' => 21711120, 'title' => 'Возражение отработано 2' },
          { 'id' => 21711123, 'title' => 'Сделано специальное предложение' },
          { 'id' => 21711126, 'title' => 'Получена договоренность о встрече', status_action: :meeting },
          { 'id' => 21711129, 'title' => 'Встреча подтверждена' },
          { 'id' => 21711132, 'title' => 'Встреча проведена' },
          { 'id' => 21711135, 'title' => 'Дожим 1 - сделано специальное предложение' },
          { 'id' => 21711138, 'title' => 'Дожим 2 и более' },
          { 'id' => 21711141, 'title' => 'Получена договоренность о финальной встрече' },
          { 'id' => 21711144, 'title' => 'Финальная встреча подтверждена' },
          { 'id' => 21711147, 'title' => 'Финальная встреча проведена' },
          { 'id' => 21710916, 'title' => 'Оплата определена' }
        ]
      }
    ].each do |item|
      pipeline = AmocrmPipeline.create!(title: item['title'], amocrm_id: item['id'], shop_id: item['shop_id'])
      item['statuses'].each do |status_item|
        amocrm_status = AmocrmStatus.find_or_initialize_by(amocrm_id: status_item['id'])
        amocrm_status.assign_attributes(title: status_item['title'], amocrm_pipeline_id: pipeline.id)
        amocrm_status.save!
      end
    end

    AmocrmStatus.find_or_create_by!(amocrm_id: AmocrmStatus::SUCCESS, title: 'Успешно реализовано')
    AmocrmStatus.find_or_create_by!(amocrm_id: AmocrmStatus::FAIL, title: 'Закрыто и не реализовано')

    [
      [1, 'Высшее медицинское образование и подготовка по дерматовенерологии'],
      [2, 'Высшее медицинское образование'],
      [3, 'Среднее медицинское образование  (сестринское дело, фельдшер (лечебное дело), акушер, фельдшер-акушер)'],
      [4, 'Среднее медицинское образование'],
      [5, 'Высшее образование'],
      [6, 'Среднее специальное образование'],
      [7, 'Неоконченное высшее/среднее'],
      [8, 'Общее образование']
    ].each do |values|
      EducationLevel.find_or_create_by!(id: values[0], title: values[1])
    end

    [
      [1, 'О', 'Очная'],
      [2, 'ОД', 'Очная с применением дистанционных образовательных технологий']
    ].each do |values|
      EducationForm.find_or_create_by!(id: values[0], short_title: values[1], title: values[2])
    end
  end

  # Configure DatabaseCleaner to reset data between tests
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation, { except: %w[education_levels education_forms amocrm_statuses shops amocrm_pipelines] }
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.render_views
end
