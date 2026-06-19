# 第5章: 再実行できるように、ドメインデータを子から順に消してから作り直す
[Tagging, Comment, Task, Tag, Project].each(&:delete_all)

user = User.find_or_create_by!(email_address: "alice@example.com") do |u|
  u.name = "Alice"
  u.password = "password"
end

bob = User.find_or_create_by!(email_address: "bob@example.com") do |u|
  u.name = "Bob"
  u.password = "password"
end

tags = %w[bug feature chore urgent].map { |name| Tag.create!(name: name) }

3.times do |i|
  project = Project.create!(name: "プロジェクト #{i + 1}", description: "サンプルプロジェクトです。")

  50.times do |n|
    task = project.tasks.create!(
      title: "タスク #{i + 1}-#{n + 1}",
      description: "サンプルのタスクです。",
      status: Task.statuses.keys.sample,
      assignee: [user, bob, nil].sample,
      due_on: Date.current + rand(0..30)
    )
    task.tags << tags.sample(rand(0..2))
    task.comments.create!(user: user, body: "最初のコメントです。") if n.even?
  end
end

puts "Seeded: #{User.count} users, #{Project.count} projects, #{Task.count} tasks, #{Comment.count} comments, #{Tag.count} tags"
