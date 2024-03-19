require 'rails_helper'

RSpec.describe "Todo管理機能", type: :system, js: true do
    #current_userの中身を生成しセットしておく＝ログイン済み状態にしておく
    let!(:current_user) { FactoryBot.create(:user_with_authentication) }
    let!(:another_user) { FactoryBot.create(:user_with_authentication) }

    before do
        authorization_stub
    end

  describe 'Todo一覧表示' do

    context 'Todoがない状態でTodo一覧ページにアクセスした場合' do
      it 'TodoがないTodo一覧ページが表示される' do
        visit todos_path
        expect(page).to have_content 'Todoがありません'
      end
    end

    context 'Todoがある状態でTodo一覧ページにアクセスした場合' do

        before do
            FactoryBot.create(:todo, user: current_user, spot: FactoryBot.create(:spot) ) 
        end

        it 'Todo一覧ページが表示され自分のTodoを確認できる' do
            visit todos_path
            expect(page).to have_content 'テストで作ったタスクです'
        end
  
        it 'Todo一覧ページが表示され自分以外のTodoがないことを確認できる' do
            visit todos_path
            expect(page).to_not have_content '別のユーザーが作成したTodoです'
        end
      end
  end


  describe 'Todo追加' do

    before do
        visit new_todo_path
        expect(page).to have_content 'AddTodo'
    end

    context 'すべての項目を入力・Trueとした場合' do
      it 'Todoが追加され、一覧ページで確認できる' do
        fill_in 'todo_content', with: '追加したTodoです'
        fill_in 'spot_name', with: '横浜駅'
        click_on 'spot_search'
        using_wait_time 10 do
            expect(page).to have_content '日本、'
        end

        #ラジオボタンが選択できないので、VIEW側を変更する必要がある
        #choose 'todo_spot_spot_group_0'
        check 'public_check'
        click_on '登録'
        expect(page).to have_content '追加したTodoです'
        expect(page).to have_content '横浜駅'
      end
    end

  end

end