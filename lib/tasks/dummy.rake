namespace :entries do

  desc 'generate dummy entries'
  task :generate_dummy => :environment do
    users = User.all

    (2.years.ago.to_date..Date.current).each do |d|
      puts "Entry: #{d}"
      rand(1..10).times do
        @entry = Entry.create(feedback: Entry.feedback_option_list.sample[1], user_id: users.sample.id, counter_id: users.sample.counter_id, date: d)
      end
    end
    puts "Done"
  end
end
