FactoryGirl.define do


  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    remember_me false
  end

  factory :project do
    title "Lorem ipsum"
    summary "My rails project"  
    
  end
  
  factory :topic do
    title "Lorem ipsum"
    summary "My rails project"  
    after_create do |topic|      
       topic.tag_list = "tag1, tag2"
    end
  end
  
  
  
  factory :tpost do
    title "Lorem ipsum"
    summary "My rails project"    
  end
  
  factory :ppost do
    title "Lorem ipsum"
    summary "My rails project"    
  end
  
  factory :post do
    user
    #after_create { |post| post.user.tag(post, :with =>  "maths, ruby, rails", :on => :tags) }
  end
end
