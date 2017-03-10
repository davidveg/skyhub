defmodule Skyhub.ImageFetcher do
  use GenServer

  alias Skyhub.Repo
  alias Skyhub.Image

  @name :image_fetcher

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts ++ [name: @name])
  end

  def get_image(image) do
    GenServer.cast(@name, {image})
  end

  # Server implementation
  def init(_), do: {:ok, []}

  def handle_cast({image}, _state) do
    %HTTPoison.Response{body: body, headers: headers} = HTTPoison.get!(image.url)
    Image.changeset(
      image,
      %{"image_binary" => body, "image_binary_type" => get_content_type(headers)}
    )
    |> Repo.update!
    |> IO.inspect
    {:noreply, []}
  end

  defp get_content_type(headers) do
    header_map = headers |> Map.new
    header_map["Content-Type"]
  end
end
