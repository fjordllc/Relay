require "application_system_test_case"

class WidgetsTest < ApplicationSystemTestCase
  test "date picker and chart survive navigation and tabs work with keyboard" do
    visit new_task_path
    assert_selector "input.flatpickr-input"
    find_field("期限").click
    assert_selector ".flatpickr-calendar.open"
    find_field("タイトル").click
    assert_no_selector ".flatpickr-calendar.open"
    visit project_path(projects(:one))
    click_on "概要", exact: true
    assert_selector "#project-tab-summary[aria-selected=true]"
    find("#project-tab-summary").send_keys(:arrow_right)
    assert_selector "#project-tab-chart[aria-selected=true]:focus"
    assert_selector "#project-panel-chart canvas"
    visit new_task_path
    assert_selector "input.flatpickr-input"
    assert_selector ".flatpickr-calendar", count: 1, visible: :all
  end

  test "infinite mode follows replacement targets to the last page" do
    visit project_path(projects(:one))
    43.times { |n| projects(:one).tasks.create!(title: "Infinite #{n}") }
    visit tasks_path(q: "Infinite", mode: "infinite")
    assert_selector "turbo-cable-stream-source[connected]", count: 2, visible: :all
    page.document.synchronize do
      assert page.evaluate_script("!!window.Stimulus.getControllerForElementAndIdentifier(document.getElementById('pagination'), 'infinite-scroll')")
    end
    page.scroll_to(find("#pagination a"), align: :center)
    within("#tasks") { assert_selector "turbo-frame", minimum: 40 }
    page.scroll_to(find("#pagination a"), align: :center) if page.has_selector?("#pagination a")
    within("#tasks") { assert_selector "turbo-frame", count: 43 }
    assert_no_selector "#pagination a"
  end
end
