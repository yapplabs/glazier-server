# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

GlazierServer::Application.load_tasks

task :ci => ["db:reset", "spec"]


if Rails.env.development? or Rails.env.test?
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task test: :spec
  task default: :spec
end
