defmodule TodoMvc.Factory do
  use ExMachina.Ecto, repo: TodoMvc.Repo
  use TodoMvc.TodoFactory
end
