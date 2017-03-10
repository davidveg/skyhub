defmodule Skyhub.ImageTest do
  use Skyhub.ModelCase

  alias Skyhub.Image

  @valid_attrs %{image_binary: "some content", image_binary_type: "some content", name: "some content", size: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Image.changeset(%Image{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Image.changeset(%Image{}, @invalid_attrs)
    refute changeset.valid?
  end
end
