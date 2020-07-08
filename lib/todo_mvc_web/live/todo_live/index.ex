defmodule TodoMvcWeb.TodoLive.Index do
  use TodoMvcWeb, :live_view

  alias TodoMvc.Dashboard
  alias TodoMvc.Dashboard.Todo

  @impl true
  def mount(_params, _session, socket) do
    changeset = Dashboard.change_todo(%Todo{})
    if connected?(socket), do: Dashboard.subscribe()

    {:ok,
     socket
     |> assign(%{todo: %Todo{}})
     |> assign(:changeset, changeset)
     |> assign(:todos, list_todos()), temporary_assigns: [todos: []]}
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset = socket.assigns.todo
      |> Dashboard.change_todo(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    save_todo(socket, socket.assigns.action, todo_params)
  end

  defp save_todo(socket, :new, todo_params) do
    case Dashboard.create_todo(todo_params) do
      {:ok, _todo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Dashboard.get_todo!(id)
    {:ok, _} = Dashboard.delete_todo(todo)

    {:noreply, assign(socket, :todos, list_todos())}
  end

  @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  defp list_todos do
    Dashboard.list_todos()
  end
end
