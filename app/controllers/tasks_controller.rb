class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  PER_PAGE = 20

  # 第23章: 検索・絞り込み / 第24章: ページネーション
  def index
    @task = Task.new
    @tasks = filtered_tasks # 現在の一覧スコープ（第17章）
    @page = [params[:page].to_i, 1].max
    @paged_tasks = @tasks.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
    @next_page = @page + 1 if @tasks.count > @page * PER_PAGE

    respond_to do |format|
      format.html
      format.turbo_stream # index.turbo_stream.erb（もっと読む）
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  # 第16章: 成功は Streams、失敗は 422
  def create
    @task = Task.new(task_params)
    if @task.save
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "タスクを作成しました。"; render :create }
        format.html { redirect_to tasks_path, notice: "タスクを作成しました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_task_form", partial: "tasks/form", locals: { task: @task }
          ), status: :unprocessable_entity
        end
        format.html do
          @tasks = filtered_tasks
          @paged_tasks = @tasks.limit(PER_PAGE)
          render :index, status: :unprocessable_entity
        end
      end
    end
  end

  # 第12章: インライン編集 / 第16章: replace
  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream # update.turbo_stream.erb（行を replace）
        format.html { redirect_to tasks_path, notice: "タスクを更新しました。", status: :see_other }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(@task), partial: "tasks/edit_frame", locals: { task: @task }
          ), status: :unprocessable_entity
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # 第16/17章: destroy 後に remove ＋ 件数更新
  def destroy
    @task.destroy!
    respond_to do |format|
      format.turbo_stream # destroy.turbo_stream.erb
      format.html { redirect_to tasks_path, notice: "タスクを削除しました。", status: :see_other }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.expect(task: [:project_id, :title, :description, :status, :due_on, :assignee_id])
  end

  # 第23章: 検索・絞り込み。LIKE のワイルドカードはエスケープ
  def filtered_tasks
    scope = Task.includes(:assignee, :tags).order(id: :desc)
    if params[:q].present?
      scope = scope.where("title LIKE ?", "%#{Task.sanitize_sql_like(params[:q])}%")
    end
    scope = scope.where(status: params[:status]) if params[:status].present?
    scope
  end
end
