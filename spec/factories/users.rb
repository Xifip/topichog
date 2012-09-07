FactoryGirl.define do
  factory :user do
    name "Michael Hartl"
    email "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    remember_me false
  end
  
  factory :project do
    title "Lorem ipsum"
    summary "My rails project"    
    user
  end
  
  factory :topic do
    title "Lorem ipsum"
    summary "My rails project"    
    user
  end
end