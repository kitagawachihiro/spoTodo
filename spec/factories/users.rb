FactoryBot.define do
    factory :user do
        distance {'0.621371'}

        factory :user_with_authentication do
            after(:create) do | user |
              create(:authentication, user: user)
            end
        end
    end

    factory :authentication do
        association :user, factory: :user
        provider {'line'}
        uid {'12345'}
        user_id {'100'}
    end

end
