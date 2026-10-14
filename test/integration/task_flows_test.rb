require "test_helper"

class TaskFlowsTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:one) }
  STREAM = { "Accept" => "text/vnd.turbo-stream.html" }

  test "literal percent underscore and backslash remain literal in SQLite search" do
    [ "100% complete", "under_score", 'back\\slash', "ordinary" ].each do |title|
      projects(:one).tasks.create!(title: title)
    end
    { "%" => "100% complete", "_" => "under_score", "\\" => 'back\\slash' }.each do |query, title|
      get tasks_path(q: query)
      assert_response :success
      assert_select "#tasks turbo-frame", count: 1
      assert_select "#tasks", text: /#{Regexp.escape(title)}/
    end
  end

  test "tags and total count remain independent of page size" do
    22.times do |n|
      projects(:one).tasks.create!(title: "Tagged #{n}", tags: [ tags(:one) ])
    end
    get tasks_path(q: "Tagged", tag_id: tags(:one).id, page: 2)
    assert_response :success
    assert_select "#task_count", text: "22"
    assert_select "#tasks turbo-frame", count: 2
  end

  test "modal failure responds with modal HTML and a full new page has one modal id" do
    post tasks_path, params: { task: { project_id: projects(:one).id, title: "" } }, headers: STREAM.merge("Turbo-Frame" => "modal")
    assert_response :unprocessable_entity
    assert_select "turbo-frame#modal dialog [role=alert]"
    get new_task_path
    assert_select "#modal", count: 1
    assert_select "dialog", count: 0
  end

  test "inline failure is a stream and invalid enum does not raise" do
    post tasks_path, params: { form_context: "inline", task: { title: "title", project_id: projects(:one).id, status: "0" } }, headers: STREAM
    assert_response :unprocessable_entity
    assert_select 'turbo-stream[target="new_task_form"]'
  end

  test "index inherited stream accept header defaults to a full HTML page" do
    get root_path, headers: STREAM
    assert_equal "text/html", response.media_type
    assert_select "h1", text: "タスク"
  end
end
