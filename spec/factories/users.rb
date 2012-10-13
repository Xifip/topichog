FactoryGirl.define do


  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    remember_me false
    after_create { |user| user.confirm! }

  end
  
  factory :profile do
    bio "my bio summary"
    linkedin_url "http://www.google.com"
    twitter_url "http://www.google.com"
    facebook_url "http://www.google.com"
    mysite_url "http://www.google.com"
    myblog_url "http://www.google.com"
    user
  end

  factory :project do
    title "Lorem ipsum"
    summary "My rails project" 
    reference "<a href='http://www.google.com'>My project reference</a>"  
    content "<div>My project content</div>"   
    tag_list "tag1, tag2, tag3"
  end

  factory :projectdraft do
    title "Lorem ipsum"
    summary "My rails project" 
    reference "<a href='http://www.google.com'>My project reference</a>"  
    content "<div>My project content</div>"   
    tag_list "tag1, tag2, tag3"
    user
  end
  
  factory :topic do
    title "Lorem ipsum"
    summary "My rails project" 
    reference "<a href='http://www.google.com'>My topic reference</a>"  
    content "<div>My topic content</div>"       
    tag_list "tag1, tag2, tag3"
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
  
#  factory :profile do
#    user
#    bio "CTO and co-founder at Careergro, testing, usability and gathering customer feedback."
#    mysite_url "http://www.careergro.com"
#  end
end
