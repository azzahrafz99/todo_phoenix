defmodule TodoMvcWeb.TodoLiveTest do
  use TodoMvcWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TodoMvc.Dashboard

  @create_attrs %{name: "some name"}
  @invalid_attrs %{name: nil}

  defp fixture(:todo) do
    {:ok, todo} = Dashboard.create_todo(@create_attrs)
    todo
  end

  defp create_todo(_) do
    todo = fixture(:todo)
    %{todo: todo}
  end

  describe "Index" do
    setup [:create_todo]

    test "lists all todos", %{conn: conn, todo: todo} do
      {:ok, _index_live, html} = live(conn, Routes.todo_index_path(conn, :index))

      assert html =~ todo.name
    end

    test "saves new todo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.todo_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#todo-form", todo: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.todo_index_path(conn, :index))

      assert html =~ "some name"
    end

    test "deletes todo in listing", %{conn: conn, todo: todo} do
      {:ok, index_live, html} = live(conn, Routes.todo_index_path(conn, :index))

      assert html =~ "some name"

      {:ok, _, html} =
        index_live
        |> element("#delete-todo-#{todo.id}", "")
        |> render_click()
        |> follow_redirect(conn, Routes.todo_index_path(conn, :index))

      refute html =~ "some name"
    end

    test "mark todo as complete", %{conn: conn, todo: todo} do
      {:ok, index_live, html} = live(conn, Routes.todo_index_path(conn, :index))

      assert index_live |> element("todo-#{todo.id}-complete-false")

      {:ok, _, html} =
        index_live
        |> element("#complete-todo-#{todo.id}", "")
        |> render_click()
        |> follow_redirect(conn, Routes.todo_index_path(conn, :index))

      assert index_live |> element("todo-#{todo.id}-complete-true")
    end

    test "mark all todo as complete", %{conn: conn, todo: todo} do
      {:ok, index_live, html} = live(conn, Routes.todo_index_path(conn, :index))

      assert index_live |> element("todo-#{todo.id}-complete-false")

      {:ok, _, html} =
        index_live
        |> element("#toggle-all", "")
        |> render_click()
        |> follow_redirect(conn, Routes.todo_index_path(conn, :index))

      assert html =~ "todo-#{todo.id}-complete-true"
    end
  end
end

