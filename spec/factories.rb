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
    stub { Faker::Internet.slug.truncate(19) }
    sort_order 0
  end
  factory :post do
    sequence(:title) { |n| "Race post #{n}" }
    write_up "Write up goes here! Exciting!"
    user
    category
  end
  factory :activity_type do
    name "Run"
  end
  factory :activity do
    start_time "2013-12-02 09:00"
    distance 20
    height_gain 500
    activity_type
    user
  end
  factory :hit do
    sequence(:ip_address) { |n| "127.0.0.#{n}" }
    association :hittable, factory: :post
  end
  factory :attachment do
    file_file_name 'image.jpg'
    file_content_type 'image/jpeg'
    file_file_size '50'
  end
end
