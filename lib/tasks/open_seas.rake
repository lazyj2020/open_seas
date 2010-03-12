namespace :open_seas do
    desc "Reset the Open Seas application environment"
    task :reset => :environment do
      Rake::Task["db:migrate:reset"].invoke
      Rake::Task["db:fixtures:load"].invoke
    end
end