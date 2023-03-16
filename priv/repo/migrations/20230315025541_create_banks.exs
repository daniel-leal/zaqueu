defmodule Zaqueu.Repo.Migrations.CreateBanks do
  use Ecto.Migration

  def change do
    create table(:banks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, size: 80, null: false
      add :code, :string, size: 8, null: false
      add :logo, :string

      timestamps()
    end

    create unique_index(:banks, [:code])
  end
end
