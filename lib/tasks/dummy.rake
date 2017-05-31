namespace :entries do

  desc 'generate dummy entries'
  task :generate_dummy => :environment do
    users = User.all.pluck(:id)
    counters = Counter.all.pluck(:id)

    (2.years.ago.to_date..Date.current).each do |d|
      puts "Entry: #{d}"
      rand(1..10).times do
        @entry = Entry.create(feedback: Entry.feedback_option_list.sample[1], user_id: users.sample, counter_id: counters.sample, date: d)
      end
    end
    puts "Done"
  end
end
