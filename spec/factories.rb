FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "longpassword"
    password_confirmation "longpassword"
    gravatar_email "user@example.com"
    
    factory :admin do
      admin true
    end
  end
end