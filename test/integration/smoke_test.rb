require "test_helper"

class SmokeTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.find_or_create_by!(email_address: "smoke@example.com") do |u|
      u.name = "Smoke"
      u.password = "password"
    end
    @project = Project.create!(name: "Smoke Project")
    @task = @project.tasks.create!(title: "Smoke Task")
    sign_in_as(@user)
  end

  test "主要ページがレンダリングされる" do
    [
      root_path, tasks_path, new_task_path, task_path(@task), edit_task_path(@task),
      project_path(@project), tasks_panel_project_path(@project),
      overview_project_path(@project), tasklist_project_path(@project)
    ].each do |path|
      get path
      assert_response :success, "#{path} が success でない"
    end
  end

  test "タスク作成が Turbo Streams で成功する" do
    assert_difference("Task.count", 1) do
      post tasks_path,
        params: { task: { project_id: @project.id, title: "新タスク", status: "todo" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success
  end

  test "タイトルが空だと 422 で返る" do
    post tasks_path,
      params: { task: { project_id: @project.id, title: "" } },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :unprocessable_entity
  end

  test "検索で絞り込める" do
    get tasks_path(q: "Smoke")
    assert_response :success
  end

  test "コメントを作成できる" do
    assert_difference("Comment.count", 1) do
      post task_comments_path(@task),
        params: { comment: { body: "hi" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
  end
end
