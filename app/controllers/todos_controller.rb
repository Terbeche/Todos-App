class TodosController < ApplicationController

  def index
    @todos = current_user.todos
    @todo = Todo.new

  end
 
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path }
        format.js
      else
        @errors = @todo.errors.full_messages
        flash[:error] = @todo.errors.full_messages.to_sentence
        format.html { redirect_to todos_path }
        format.js
      end
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_path }
      format.js
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date)
  end
end