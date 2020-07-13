defmodule TodoMvc.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string
      add :complete, :boolean, default: false

      timestamps()
    end

  end
end
