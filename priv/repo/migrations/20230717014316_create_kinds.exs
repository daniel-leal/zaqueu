defmodule Zaqueu.Repo.Migrations.CreateKinds do
  use Ecto.Migration

  def change do
    create table(:kinds, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string

      timestamps()
    end
  end
end
