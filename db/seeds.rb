1.times do |counter|
  Counter.create!([
    { name: "Jakarta 1" },
    { name: "Jakarta 2" },
    { name: "Jakarta 3" },
    { name: "Jakarta 4" },
    { name: "Jakarta 5" }
    ])
end

counter_ids = Counter.all.pluck(:id)

1.times do |user|
  User.create([
    {
      username: 'rizki',
      email: 'rizki@3ribulabs.com',
      firstname: 'rizki',
      lastname: 'muhammad',
      password: '123456',
      counter_id: counter_ids.sample,
      role: "CS"
    },
    {
      username: 'suhendra',
      email: 'suhendra@3ribulabs.com',
      firstname: 'suhendra',
      lastname: 'katrali',
      password: '123456',
      counter_id: counter_ids.sample,
      role: "CS"
    },
    {
      username: 'adhi',
      email: 'adhi@3ribulabs.com',
      firstname: 'adhi',
      lastname: 'guna',
      password: '123456',
      counter_id: counter_ids.sample,
      role: "CS"
    },
    {
      username: 'aulia',
      email: 'aulia@3ribulabs.com',
      firstname: 'aulia',
      lastname: 'sabril',
      password: '123456',
      counter_id: counter_ids.sample,
      role: "CS"
    },
    {
      username: 'syaiful',
      email: 'syaiful@3ribulabs.com',
      firstname: 'syaiful',
      lastname: 'sabril',
      password: '123456',
      counter_id: counter_ids.sample,
      role: "Admin"
    }
    ])
end
puts "END"
