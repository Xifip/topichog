FactoryGirl.define do


  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    remember_me false
  end

=begin
  factory :user do
    name "Michael Hartl"
    email "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    remember_me false
  end
=end 

  factory :project do
    title "Lorem ipsum"
    summary "My rails project"  
  end
  
  factory :topic do
    title "Lorem ipsum"
    summary "My rails project"  
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

  end
end
