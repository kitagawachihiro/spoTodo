class TodoSpot
    include ActiveModel::Model

    #ゲッターとセッターをセット。form_withの引数として利用できるようになる。
    #todo（content, user_id, public)
    #spot (name, address, latitude, longitude)
    attr_accessor :content, :user_id, :public, :name, :address, :latitude, :longitude

    #todoの要素に対するバリデーション
    validates :content, presence: true
    validates :user_id, presence: true

    #spotの要素に対するバリデーション
    validates :name, presence: true
    validates :address, presence: true, length: { maximum: 100 }
    validates :latitude, presence: true
    validates :longitude, presence: true

    def save
        spot = Spot.find_by(address: address)
        spot = Spot.new(name: name, address: address, latitude: latitude, longitude: longitude) if spot.nil?
        current_user = User.find(user_id)
        current_user.todos.create(content: content, spot_id: spot.id, public: public) if spot.save
    end
end
