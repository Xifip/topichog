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

      title1 = Faker::Lorem.words(1)
      summary1 = Faker::Lorem.sentence(2)
      title2 = Faker::Lorem.words(1)
      summary2 = Faker::Lorem.sentence(2)
      taglist = Faker::Lorem.words(3).join(', ')
            
      p1 = Project.create!(title: title1, summary: summary1)   
      user.posts.create!(postable_id: p1.id, postable_type: "Project")
      t1 = Topic.create!(title: title2, summary: summary2, tag_list: taglist) 
      @post = user.posts.build 
      @post.postable = t1
      @post.user.tag(@post, :with =>  t1.tag_list, :on => :tags)
      @post.save!  
      #user.posts.create!(postable_id: t1.id, postable_type: "Topic")       
    end     
  end  
end 
    

def make_likes
  posts = Post.all
  post = posts.first
  users = User.all
  user = users.first
  liked_posts = posts[2..50]
  likers = users[3..40]
  liked_posts.each do |liked_post| 
    user.like!(liked_post) if liked_post.user != user
  end
  likers.each { |liker| liker.like!(post) if post.user != liker }
end 
    
def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
