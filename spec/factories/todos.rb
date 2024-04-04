FactoryBot.define do
    factory :todo do
        content {"テスト作成のTodoです"}
        finished { false }
        public { true }
        spot
        user
    end
end
