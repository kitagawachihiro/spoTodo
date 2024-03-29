class TodoSpot
  include ActiveModel::Model

  # ゲッターとセッターをセット。form_withの引数として利用できるようになる。
  # todo（id, content, user_id, public)
  # spot (name, address, latitude, longitude)
  attr_accessor :content, :user_id, :public, :name, :address, :latitude, :longitude

  # todoの要素に対するバリデーション
  validates :content, presence: true
  validates :user_id, presence: true

  # spotの要素に対するバリデーション
  validates :name, presence: true
  validates :address, presence: true, length: { maximum: 100 }
  validates :latitude, presence: true
  validates :longitude, presence: true

  # todo_spotを生成した時に実行される
  def initialize(user, params = {}, todo)
    # 変数が nil または false である場合にTodo.newをする
    @todo = todo

    if @todo.id.present?
      # todospotをセット
      assign_attributes(content: @todo.content, user_id: @todo.user_id, public: @todo.public, name: @todo.spot.name,
                        address: @todo.spot.address, latitude: @todo.spot.latitude, longitude: @todo.spot.longitude)
    else
      # @todoをセット
      @todo.assign_attributes(user_id: user.id, content: params[:content])
    end

    @old_spot = @todo.spot
  end

  def save(params)
    setting_spot(params)

    spot = Spot.find_by(address: @address)
    spot = Spot.new(name: @name, address: @address, latitude: @latitude, longitude: @longitude) if spot.nil?

    return unless spot.save

    @todo.public = params[:public]
    @todo.spot_id = spot.id
    @todo.save
  end

  def update(params)
    setting_spot(params)

    spot = Spot.find_by(address: @address)

    if spot.nil?
      # spotが新しい場所に変わっていた場合
      new_spot = Spot.new(name: @name, address: @address, latitude: @latitude, longitude: @longitude)
      new_spot.save!
      @todo.update(content: params[:content], spot_id: new_spot.id, public: params[:public])
    else
      # spotは変わらずもしくはspot登録があった場合
      @todo.update(content: params[:content], spot_id: spot.id, public: params[:public])
    end

    destroy_empty_spot(@old_spot)
  end

  private

  def setting_spot(params)
    # spot_groupの値によって、name、address、latitude、longitudeのパラメーター名が変わる
    return unless (0..2).include?(params[:spot_group].to_i)

    index = params[:spot_group].to_i
    @name = params[:"name_#{index}"]
    @address = params[:"address_#{index}"]
    @latitude = params[:"latitude_#{index}"]
    @longitude = params[:"longitude_#{index}"]
  end

  # 紐づくtodoが0になってしまったspotは削除する
  def destroy_empty_spot(old_spot)
    old_spot.destroy if old_spot.todos.empty?
    true
  end
end
