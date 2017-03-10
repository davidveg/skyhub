defmodule Skyhub.ImageConverter do
  use GenServer

  alias Skyhub.Repo
  alias Skyhub.Image
  alias Skyhub.Helper
  import Mogrify
  import Ecto.Query

  @name :image_converter

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts ++ [name: @name])
  end

  def create_images(image) do
    GenServer.cast(@name, {image})
  end

  # Server implementation
  def init(_), do: {:ok, []}

  def handle_cast({image}, _state) do
    query = from i in Image
    images = Repo.all(query)
    for image <- images do
      create_new_file(image, "small")
      create_new_file(image, "medium")
      create_new_file(image, "large")
    end
    {:noreply, []}
  end

  defp create_new_file(image, size) do
    case size do
      "small" -> create_small(image)
      "medium" -> create_medium(image)
      "large" -> create_large(image)
    end
  end

  defp create_small(image) do
    name = image.name <> "_small"
    image_path = Path.join(File.cwd!, "temp") <> "/" <> image.name <> "_tmp.jpg"
    File.write!(image_path, image.image_binary)
    open(image_path) |> resize("320x240") |> save
    params = %{ "name"=> name, "url" => Skyhub.Endpoint.url, "size" => "small", "image_binary" => File.read!(image_path), "image_binary_type" => "image/jpeg"}
    save_new(params)
  end

  defp create_medium(image) do
    name = image.name <> "_medium"
    image_path = Path.join(File.cwd!, "temp") <> "/" <> image.name <> "_tmp.jpg"
    File.write!(image_path, image.image_binary)
    open(image) |> resize("384x288") |> save
    params = %{ "name"=> name, "url" => Skyhub.Endpoint.url, "size" => "medium", "image_binary" => File.read!(image_path), "image_binary_type" => "image/jpeg"}
    save_new(params)
  end

  defp create_large(image) do
    name = image.name "_large"
    image_path = Path.join(File.cwd!, "temp") <> "/" <> image.name <> "_tmp.jpg"
    IO.inspect(image_path)
    File.write!(image_path, image.image_binary)
    file = open(image) |> resize("640x480") |> save
    params = %{ "name"=> name, "url" => Skyhub.Endpoint.url, "size" => "large", "image_binary" => file, "image_binary_type" => "image/jpeg"}
    save_new(params)
  end

  defp save_new(params) do
    if Helper.check_existence(params) do
      changeset = Image.changeset(%Image{}, params)
      case Repo.insert(changeset) do
        {:ok} -> {:noreply, []}
        {:error} -> IO.puts "Error on saving #{params.name} to database"
      end
    end
  end

end
