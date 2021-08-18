set :output, {error: 'log/error.log', standard: 'log/cron.log'}
job_type :runner, "cd :path && rvmsudo -u www-data bundle exec rails runner -e :environment ':task' :output"
job_type :rake, 'cd :path && rvmsudo -u www-data RAILS_ENV=:environment bundle exec rake :task :output'

every 5.minutes do
  runner 'LoadLetters.do'
end

every 5.minutes do
  runner 'GroupSubscriptions::ResetPaymentsTask.run'
end

every 10.minutes do
  runner 'NotifyAboutWebinar.run'
end

every 30.minutes do
  runner 'UpdateSmsStatuses.do'
end

every 12.hours do
  runner 'AmocrmImport.enqueue!', environment: :production
end

every 1.day, at: '1:00am' do
  runner 'IndicesImport.run'
end

every 1.day, at: '1:00am' do
  runner 'OldJobsService.run'
end

every 1.day, at: '2:00am' do
  runner 'ExtendTraining.run'
end

every 1.day, at: '3:00am' do
  runner 'ExpulsionTask.run'
end

every 1.day, at: '4:00am' do
  runner 'CourseNearestGroupUpdater.run'
end

every 1.minute do
  runner 'AmoRequestsCleaner.clear'
end

every 1.day, at: '6:00am' do
  runner "Mindbox::CsvApiOperation.perform('CustomersImport')"
  runner "Mindbox::CsvApiOperation.perform('OrdersImport')"
end

every 1.day, at: '10:00am' do
  runner 'ExpulsionNotifications.run'
end

every 1.day, at: '10:00am' do
  runner 'Calls::NotificationTask.run'
end

every 1.day, at: '14:00am' do
  runner 'Calls::AmocrmNoticesTask.run'
end

every 1.day, at: '11:00am' do
  runner 'ExpiredEducationDebtsNotification.run'
end

every 1.day, at: '11:00am' do
  runner 'NotificationsService.run'
end

every 1.day, at: '11:00am' do
  runner 'VacanciesNotificationService.run'
end

# Рассылки отключены в соответствии с заданием
#every 1.week, at: '12:00pm' do
#  runner 'WeeklyReminder.run'
#end

#every :friday, at: '13:00pm' do
#  runner 'ProgressReminder.run'
#end

every 1.day, at: '14:00pm' do
  runner 'AcademicDebtsNotification.run'
end

every 1.day, at: '9:00am' do
  runner 'GroupPlacesOverNotifier.run'
end

every 1.day, at: '6:00pm' do
  runner 'GroupPlacesOverNotifier.run'
end

every 1.day, at: '11:00pm' do
  runner 'RatingActualizer.new.run'
end

every 1.day, at: '12:00pm' do
  runner 'SubscriptionSuccessNotifier.run'
end

every 2.hour do
  rake 'ts:index'
end

every 1.hour do
  rake 'ts:restart'
end

every 1.day do
  rake 'sitemap:refresh'
end