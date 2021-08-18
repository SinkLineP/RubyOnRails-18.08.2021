Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay = 5
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 8.hours
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.default_queue_name = 'default'