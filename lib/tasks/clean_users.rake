namespace :clean_users do
  desc "This task destroy all false users"
  task :generate => :environment do
    puts 'Destroy all false users...'
    CleanUsers.perform_later
    puts "Done."
  end
end
