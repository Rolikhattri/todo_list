class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks.sort_by &:status
    @all_count = current_user.tasks.count
    @complete_count = current_user.tasks.where(:status => "Complete").count
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    @task = Task.find(params[:task_id])
    @task.update(:status => "Complete")
    @tasks = current_user.tasks.sort_by &:status
    @all_count = current_user.tasks.count
    @complete_count = current_user.tasks.where(:status => "Complete").count
    respond_to do |format|
      format.html { render :index}
      format.json { head :no_content }
    end
  end

  def active
    @task = Task.find(params[:task_id])
    @task.update(:status => "Active")
    @tasks = current_user.tasks.sort_by &:status
    @all_count = current_user.tasks.count
    @complete_count = current_user.tasks.where(:status => "Complete").count
    respond_to do |format|
      format.html { render :index}
      format.json { head :no_content }
    end
  end

  def filter
    @all_count = current_user.tasks.count
    @complete_count = current_user.tasks.where(:status => "Complete").count
    if(params[:type] == "All")
      @tasks = current_user.tasks.sort_by &:status
    else
      @tasks = current_user.tasks.where(:status => params[:type])
      @status = params[:type]
    end

    respond_to do |format|
      format.html { render :index}
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /tasks/
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:desc, :status, :user_id)
    end
end
