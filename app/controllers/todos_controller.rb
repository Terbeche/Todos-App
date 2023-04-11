class TodosController < ApplicationController
  before_action :require_user!
  before_action :set_todo, only: %i[ show edit update destroy ]

  def index
    @todos = current_user.todos
    @todo = Todo.new

  end
   # GET /todos/1 or /todos/1.json
   def show
   end
 
   # GET /todos/new
   def new
     @todo = Todo.new
   end
 
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    respond_to do |format|
      if @todo.save
        format.html { redirect_to todo_url(@todo), notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        @errors = @todo.errors.full_messages
        flash[:error] = @todo.errors.full_messages.to_sentence
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
     end
    end
  end

  def update
    @todo = Todo.find(params[:id])
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_url, notice: "Todo was successfully updated" }
        format.json { render json: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

   def edit
    @todo = Todo.find(params[:id])
  end

  def destroy
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_url, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
  def set_todo
    @todo = Todo.find(params[:id])
  end
  def todo_params
    params.require(:todo).permit(:title, :description, :due_date)
  end
end