# This file is used by Rack-based servers to start the application.

require 'unicorn'
# Unicorn self-process killer
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (250 * (1024**2)), (300 * (1024**2))

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
