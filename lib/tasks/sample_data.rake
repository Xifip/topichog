namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  User.create!(name: "Example User",
                email: "example@topichog.com",
                password: "foobar",
                password_confirmation: "foobar")
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@topichog.com"
      password = "password"
      User.create!(name: name,
                    email: email,
                    password: password,
                    password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    50.times do
      title = Faker::Lorem.words(1)
      summary = Faker::Lorem.sentence(2)
      users.each { |user| user.projects.create!(title: title, summary: summary) }
    end
  end
end