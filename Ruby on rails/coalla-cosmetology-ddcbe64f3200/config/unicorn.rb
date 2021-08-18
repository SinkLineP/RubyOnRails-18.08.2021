require 'coalla-deploy/unicorn'
application_name = (ENV['RAILS_ENV'] == 'production') ? 'sikorsky.academy' : 'cosmetic.coalla.ru'
Coalla::Unicorn.init(self, deploy_to: "/var/www/virtual-hosts/#{application_name}",
                     timeout: 3600,
                     worker_processes: (ENV['RAILS_ENV'] == 'production') ? 10 : 1)