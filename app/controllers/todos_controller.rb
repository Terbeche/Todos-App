# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :require_user!
  before_action :set_todo, only: %i[show edit update destroy]

  def index
    @todos = current_user.todos.order(:position)
    @todo = Todo.new
  end

  # GET /todos/1 or /todos/1.json
  def show; end

  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    @todos = current_user.todos
    @todo.position = @todos.maximum(:position).to_i + 1

    respond_to do |format|
      if @todo.save
        format.html { render partial: 'todo', locals: { todo: @todo } }
      else
        format.json { render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @todo = Todo.find(params[:id])
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_url, notice: 'Todo was successfully updated' }
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
      format.html { redirect_to todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_completed
    @todo = Todo.find(params[:id])
    @todo.update(completed: params[:completed])
    head :no_content
  end

  def update_positions
    puts "positions: #{params[:positions].inspect}"

    params[:positions].each_with_index do |id, index|
      Todo.find(id).update(position: index + 1)
    end
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date)
  end
end
