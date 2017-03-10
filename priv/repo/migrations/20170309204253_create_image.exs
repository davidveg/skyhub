defmodule Skyhub.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :name, :string
      add :url, :string
      add :size, :string
      add :image_binary, :binary
      add :image_binary_type, :string

      timestamps()
    end

  end
end
