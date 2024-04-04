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
            expect(page).to have_content 'テスト作成のTodoです'
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
    context 'すべての項目を入力・チェックボックスをチェックした場合' do
        it 'Todoが追加され、一覧ページで確認できる' do
            fill_in 'todo_content', with: '追加したTodoです'
            fill_in 'spot_name', with: '横浜駅'
            click_on 'spot_search'
            using_wait_time 10 do
                expect(page).to have_css '#btnlabel0'
            end
            #ラジオボタンが選択できないので、VIEW側を変更する必要がある
            #choose 'todo_spot_spot_group_0'
            check 'public_check'
            click_on '登録'
            expect(page).to have_content '追加したTodoです'
            expect(page).to have_content '横浜駅'
        end
    end
    context '何をしたい？を未入力にした場合' do
        it 'Todoが追加できない' do
            fill_in 'spot_name', with: '横浜駅'
            click_on 'spot_search'
            using_wait_time 10 do
                expect(page).to have_css '#btnlabel0'
            end
            check 'public_check'
            click_on '登録'
            expect(page).to have_content 'Todoが登録できませんでした'
        end
    end
    context 'どこで？を未入力にした場合' do
        it '検索されない・Todoの登録ボタンがでない' do
            fill_in 'todo_content', with: '追加したTodoです'
            click_on 'spot_search'
            using_wait_time 10 do
                expect(page).to have_no_css '#btnlabel0'
            end
            check 'public_check'
            expect(page).to_not have_content '登録'
        end
    end
    context '公開のチェックボックスをチェックしなかった場合' do
        it 'Todoが追加され、一覧ページで確認できる' do
            fill_in 'todo_content', with: '追加したTodoです'
            fill_in 'spot_name', with: '横浜駅'
            click_on 'spot_search'
            using_wait_time 10 do
                expect(page).to have_css '#btnlabel0'
            end
            click_on '登録'
            expect(page).to have_content '追加したTodoです'
            expect(page).to have_content '横浜駅'
        end
    end
  end

  describe 'Todo編集' do
    #インスタンス変数の定義。let!はテストが実行される前（it内のテストが実行される前）に評価（定義）される。
    let!(:exist_todo) { FactoryBot.create(:todo, user: current_user, spot: FactoryBot.create(:spot) ) }
    before do
        visit edit_todo_path(exist_todo)
        expect(page).to have_content 'EditTodo'
    end
    context 'すべての項目を変更した場合' do
        it 'Todoが変更され、一覧ページで確認できる' do
            fill_in 'todo_content', with: '変更したTodoです'
            fill_in 'spot_name', with: '池袋駅'
            sleep 5
            click_on 'spot_search'
            sleep 5
            expect(page).to have_css '#btnlabel1'
            uncheck 'public_check'
            click_on '更新'
            expect(page).to have_content '変更したTodoです'
            expect(page).not_to have_content 'テスト作成のTodoです'
            expect(page).to have_content '池袋駅'
            expect(page).not_to have_content '東京駅'
        end
    end
    context '何をしたい？を変更した場合' do
        it 'Todoが変更され、一覧ページで確認できる' do
            fill_in 'todo_content', with: '変更したTodoです'
            expect(page).to have_css '#btnlabel1'
            click_on '更新'
            expect(page).to have_content '変更したTodoです'
            expect(page).not_to have_content 'テスト作成のTodoです'
            expect(page).to have_content '東京駅'
        end
    end
    context 'どこで？を変更した場合' do
        it 'Todoが変更され、一覧ページで確認できる' do
            fill_in 'spot_name', with: '池袋駅'
            sleep 5
            click_on 'spot_search'
            sleep 5
            expect(page).to have_css '#btnlabel1'
            click_on '更新'
            expect(page).to have_content 'テスト作成のTodoです'
            expect(page).to have_content '池袋駅'
            expect(page).not_to have_content '東京駅'
        end
    end
    context '公開のチェックを変更した場合' do
        it 'Todoが変更され、一覧ページで確認できる' do
            uncheck 'public_check'
            click_on '更新'
            expect(page).to have_content 'テスト作成のTodoです'
            expect(page).to have_content '東京駅'
        end
    end
  end

  describe 'Todo削除' do
    #インスタンス変数の定義。let!はテストが実行される前（it内のテストが実行される前）に評価（定義）される。
    let!(:exist_todo) { FactoryBot.create(:todo, user: current_user, spot: FactoryBot.create(:spot) ) }
    before do
        visit todos_path
        expect(page).to have_content 'テスト作成のTodoです'
        expect(page).to have_content '東京駅'
    end
    context '既存のTodoの削除ボタンを押した場合' do
        it 'Todoが削除され、一覧ページに何もないことが確認できる' do
            click_link nil, href: todo_path(exist_todo)
            page.driver.browser.switch_to.alert.accept
            expect(page).to have_content 'Todoがありません'
        end
    end 
  end

  describe 'Todoのチェックとレビュー' do
    let!(:exist_todo) { FactoryBot.create(:todo, user: current_user, spot: FactoryBot.create(:spot) ) }
    before do
        visit todos_path
        expect(page).to have_content 'テスト作成のTodoです'
        expect(page).to have_content '東京駅'
    end
    context '既存のTodoの削除ボタンを押した場合' do
        it 'Todoが削除され、一覧ページに何もないことが確認できる' do
            click_link nil, href: todo_path(exist_todo)
            page.driver.browser.switch_to.alert.accept
            expect(page).to have_content 'Todoがありません'
        end
    end 
  end


end