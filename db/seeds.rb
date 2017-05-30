1.times do |counter|
  Counter.create!([
    { name: "Jakarta 1" },
    { name: "Jakarta 2" },
    { name: "Jakarta 3" },
    { name: "Jakarta 4" },
    { name: "Jakarta 5" }
    ])
end

1.times do |user|
  User.create([
    {
      username: 'rizki',
      email: 'rizki@3ribulabs.com',
      firstname: 'rizki',
      lastname: 'muhammad',
      password: '123456',
      counter_id: 1
    },
    {
      username: 'suhendra',
      email: 'suhendra@3ribulabs.com',
      firstname: 'suhendra',
      lastname: 'katrali',
      password: '123456',
      counter_id: 2
    },
    {
      username: 'adhi',
      email: 'adhi@3ribulabs.com',
      firstname: 'adhi',
      lastname: 'guna',
      password: '123456',
      counter_id: 3

    },
    {
      username: 'aulia',
      email: 'aulia@3ribulabs.com',
      firstname: 'aulia',
      lastname: 'sabril',
      password: '123456',
      counter_id: 4
    },
    {
      username: 'syaiful',
      email: 'syaiful@3ribulabs.com',
      firstname: 'syaiful',
      lastname: 'sabril',
      password: '123456',
      counter_id: 5
    }
    ])
end
