defmodule Skyhub.ImageController do
  use Skyhub.Web, :controller

  alias Skyhub.Helper
  alias Skyhub.Image
  alias Skyhub.Repo
  alias Skyhub.JSONFetch
  alias Skyhub.ImageFetcher
  alias Skyhub.ImageConverter
  alias Skyhub.ExtractMap

  def index(conn, _params) do
    images = Repo.all(Image)
    render(conn, "index.html", images: images)
  end

  # GET http://localhost:4000/api/v1/images/
  def generate(conn, _params) do
    urls = process
    for image <- urls do
      img_struct = Helper.struct_from_map(image, as: %Image{})
      url_to_call = Map.get(img_struct, :url)
      name = Enum.join(Enum.take(String.split(Enum.join(Enum.take(String.split(url_to_call, "/"), -1),""),"."),1),"")
      params = Map.from_struct(%{img_struct | name: name, size: "original", url: url_to_call})
      if Helper.check_existence(params) do
        changeset = Image.changeset(%Image{}, params)
        case Repo.insert(changeset) do
          {:ok, image} ->
            ImageFetcher.get_image(image)
        end
      end
    end
    ImageConverter.create_images({:pop})
    conn
    |> put_flash(:info, "Images processed successfully.")
    |> redirect(to: image_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)
    render(conn, "show.html", image: image)
  end

  def delete(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(image)
    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: image_path(conn, :index))
  end

  def image(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)
    conn
    |> put_resp_content_type(image.image_binary_type, "utf-8")
    |> send_resp(200, image.image_binary)
  end

  defp process do
    JSONFetch.fetch
    |> ExtractMap.extract_from_body
  end
end
