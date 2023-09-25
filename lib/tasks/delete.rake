namespace :delete do
    desc "Todoをチェックしてから1週間以上経過していた場合は削除する" #description（説明）
    task delete: :environment do #task_nameは自由につけられる
        Todo.where("(finished = ?) AND (updated_at < ?)", true,Time.current.ago(7.days)).each do |checked_todo|
            checked_todo.delete
        end
    end
end
