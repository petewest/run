FactoryGirl.define do
  factory :user do
    name     "Peter"
    email    "test@example.com"
    password "longpassword"
    password_confirmation "longpassword"
    gravatar_email "user@example.com"
  end
end