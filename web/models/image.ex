defmodule Skyhub.Image do
  use Skyhub.Web, :model

  schema "images" do
    field :name, :string
    field :url, :string
    field :size, :string
    field :image_binary, :binary
    field :image_binary_type, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :size, :image_binary, :image_binary_type])
    |> validate_required([:name, :size])
  end
end
