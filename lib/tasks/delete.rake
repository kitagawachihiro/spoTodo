namespace :delete do
  desc 'Todoをチェックしてから1週間以上経過していた場合は削除する' # description（説明）
  task delete: :environment do # task_nameは自由につけられる
    Todo.where('(finished = ?) AND (updated_at < ?)', true, Time.current.ago(1.days)).each(&:delete)
  end
end
