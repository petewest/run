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
  factory :category do
    name "Race"
    stub "race"
    sort_order 0
  end
  factory :post do
    title "Race day!"
    write_up "Write up goes here! Exciting!"
    user
    category
  end
end
