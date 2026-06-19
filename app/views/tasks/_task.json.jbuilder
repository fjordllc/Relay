json.extract! task, :id, :project_id, :title, :description, :status, :due_on, :assignee_id, :created_at, :updated_at
json.url task_url(task, format: :json)
