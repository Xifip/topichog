namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_projects
    make_topics
    make_relationships
   end
end

def make_users 
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
end      
    
def make_projects  
  users = User.all(limit: 6)
  50.times do
    title = Faker::Lorem.words(1)
    summary = Faker::Lorem.sentence(2)
    users.each { |user| user.projects.create!(title: title, summary: summary) }
  end
end 
 
def make_topics  
  users = User.all(limit: 6)
  50.times do
    title = Faker::Lorem.words(1)
    summary = Faker::Lorem.sentence(2)
    users.each { |user| user.topics.create!(title: title, summary: summary) }
  end
end 
    
def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end