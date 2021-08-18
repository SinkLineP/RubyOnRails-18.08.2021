namespace :corona do
  desc 'Send mail virus COVID-19 Info'
  task virus: :environment do
    ids2 = GroupSubscription.where("amocrm_status_id = 1 and (begin_on between '2020-03-17' and '2020-04-30' or end_on between '2020-03-17' and '2020-04-30')").map(&:student_id).uniq

    Student.find(ids2).each do |student|
      CosmetologyMailer.notify_corona_virus_mail(student).deliver!
    end
  end
end
