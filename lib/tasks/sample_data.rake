namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    #make_projects
    #make_topics
    make_posts
    make_relationships
    make_likes
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

def make_posts  
  users = User.all(limit: 6)
  users.each do |user|
    10.times do
      #title1 = Faker::Lorem.words(1)
      #summary1 = Faker::Lorem.sentence(2)
      #title2 = Faker::Lorem.words(1)
      #summary2 = Faker::Lorem.sentence(2)
      title3 = Faker::Lorem.words(1)
      summary3 = Faker::Lorem.sentence(2)
      title4 = Faker::Lorem.words(1)
      summary4 = Faker::Lorem.sentence(2)
      #p1 = Ppost.create!(title: title1, summary: summary1)   
      #user.posts.create!(postable_id: p1.id, postable_type: "Ppost")
      #t1 = Tpost.create!(title: title2, summary: summary2)   
      #user.posts.create!(postable_id: t1.id, postable_type: "Tpost") 
      p2 = Project.create!(title: title3, summary: summary3)   
      user.posts.create!(postable_id: p2.id, postable_type: "Project")
      t2 = Topic.create!(title: title4, summary: summary4)   
      user.posts.create!(postable_id: t2.id, postable_type: "Topic")       
    end     
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

def make_likes
  posts = Post.all
  post = posts.first
  users = User.all
  user = users.first
  liked_posts = posts[2..50]
  likers = users[3..40]
  liked_posts.each { |liked_post| user.like!(liked_post) }
  likers.each { |liker| liker.like!(post) }
end 
    
def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
