defmodule TodoMvcWeb.TodoLive.Index do
  use TodoMvcWeb, :live_view

  alias TodoMvc.Dashboard
  alias TodoMvc.Dashboard.Todo

  @impl true
  def mount(_params, _session, socket) do
    changeset = Dashboard.change_todo(%Todo{})
    if connected?(socket), do: Dashboard.subscribe()

    {
      :ok,
      socket
        |> assign(%{todo: %Todo{}})
        |> assign(:changeset, changeset)
        |> assign(:todos, list_todos()), temporary_assigns: [todos: [list_todos()]]
    }
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset =
      socket.assigns.todo
        |> Dashboard.change_todo(todo_params)
        |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    Dashboard.create_todo(todo_params)
    {
      :noreply,
      socket
        |> push_redirect(to: Routes.todo_index_path(socket, :index))
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    todo     = Dashboard.get_todo!(id)
    {:ok, _} = Dashboard.delete_todo(todo)

    {:noreply, assign(socket, :todos, list_todos())}
  end

  def handle_event("update", %{"id" => id}, socket) do
    todo     = Dashboard.get_todo!(id)
    Dashboard.update_todo(todo, %{complete: !todo.complete, name: todo.name})

    {
      :noreply,
      socket
        |> push_redirect(to: Routes.todo_index_path(socket, :index))
    }
  end

  @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  def handle_info({:todo_deleted, todo}, socket) do
    {:noreply, assign(socket, :todos, fn todos -> [todo | todos] end)}
  end

  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  defp list_todos do
    Dashboard.list_todos()
  end
end
