# 第16章: コメントの追加・削除を Turbo Streams で
class Tasks::CommentsController < ApplicationController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params.merge(user: Current.user))
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task }
      end
    else
      redirect_to @task, alert: "コメントを入力してください。", status: :see_other
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
      format.html { redirect_to @task }
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
