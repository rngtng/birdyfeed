#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Birdyfeed::Application.load_tasks

desc "reset"
task :reset => ['db:drop', 'db:create', 'db:migrate', 'db:seed', 'db:test:prepare']

task :travis do
  ["rake db:create", "rake db:schema:load", "rake spec"].each do |cmd|
    puts "Starting to run #{cmd}..."
    # export DISPLAY=:99.0 &&
    system("bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
