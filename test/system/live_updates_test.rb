require "application_system_test_case"

class LiveUpdatesTest < ApplicationSystemTestCase
  test "remote changes preserve filtering and show the empty state" do
    fill_in "タイトルで検索", with: "Live only", fill_options: { clear: :backspace }
    assert_field "タイトルで検索", with: "Live only"
    assert_current_path tasks_path, ignore_query: true
    assert_selector "turbo-cable-stream-source[connected]", count: 2, visible: :all
    assert_text "タスクはありません。"
    task = projects(:one).tasks.create!(title: "Live only task")
    assert_selector "##{dom_id(task)}", text: "Live only task"
    assert_no_text "タスクはありません。"
    projects(:one).tasks.create!(title: "Other task")
    within("#tasks") { assert_no_text "Other task" }
    task.destroy!
    assert_no_selector "##{dom_id(task)}"
    within("#task_list") { assert_text "タスクはありません。" }
  end

  test "remote updates do not replace an unsaved edit" do
    task = tasks(:one)
    within "##{dom_id(task)}" do
      click_on "編集"
      fill_in "タイトル", with: "Unsaved local title", fill_options: { clear: :backspace }
      assert_field "タイトル", with: "Unsaved local title"
    end
    task.update!(title: "Changed remotely")
    assert_text "更新があります。"
    within("##{dom_id(task)}") { assert_field "タイトル", with: "Unsaved local title" }
  end

  test "moving a task out of the selected project removes it" do
    task = tasks(:one)
    visit tasks_path(project_id: task.project_id)
    assert_selector "turbo-cable-stream-source[connected]", count: 2, visible: :all
    task.update!(project: projects(:two))
    assert_no_selector "##{dom_id(task)}"
    assert_text "タスクはありません。"
  end
end
