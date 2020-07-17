defmodule TodoMvc.TodoFactory do
  defmacro __using__(_opts) do
    alias TodoMvc.Dashboard.Todo
    alias FakerElixir, as: Faker

    quote do
      def todo_factory do
        %Todo{
          name: Faker.Lorem.words,
          complete: false
        }
      end
    end
  end
end

