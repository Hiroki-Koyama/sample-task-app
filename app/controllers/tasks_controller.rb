class TasksController < ApplicationController
  
  before_action :set_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :correct_user

  def index
    @tasks = @user.tasks.all.order("id DESC")
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = @user.tasks.new(task_params)
    if @task.save
      flash[:success] = "タスクを新規作成しました。"
      redirect_to user_tasks_path(@user)
    else
      flash[:danger] = "エラーです。"
      render :new
    end
  end
  
  def show
  end
  
  def edit
    unless @user == current_user
      flash[:danger] = "権限がありません。"
      redirect_to user_tasks_path(@user)
    end
  end
  
  def update
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました。"
      redirect_to user_task_path(@user, @task)
    else
      flash[:danger] = "エラーです。"
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = "タスクを削除しました。"
    redirect_to user_tasks_path(@user)
  end
  
  
  private

  def set_user
    @user = User.find(params[:user_id])
  end
  
  def set_task
    unless @task = @user.tasks.find_by(id: params[:id])
      flash[:danger] = "権限がありません。"
      redirect_to user_tasks_path(@user)
    end
  end
  
  def task_params
    params.require(:task).permit(:name, :description)
  end
  
end
