# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

GlazierServer::Application.load_tasks

task :ci => ['db:create', 'db:migrate', :spec]

if Rails.env.development? or Rails.env.test?
  task default: :spec
  task test: :spec
end
