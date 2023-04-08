# frozen_string_literal: true

json.array! @todos, partial: 'todos/todo', as: :todo
