FactoryBot.define do
  factory :user do
    username {'test1'}
    first_name { 'abc' }
    last_name {'dfdf'}
    email {'abc1@gmail.com'}
    age {14}
    password {"12345678"}
    password_confirmation {"12345678"}
  end
end






