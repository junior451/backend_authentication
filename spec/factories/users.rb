FactoryBot.define do
  factory :user do
    email { "myuser@gmail.ac.uk" }
    username { "myuser" }
    admin { false }
    password { "my_password" }
  end
end
