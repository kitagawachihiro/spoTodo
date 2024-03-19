FactoryBot.define do
    factory :todo do
        content {"テストで作ったタスクです"}
        finished { false }
        public { false }
        spot
        user
    end
end
