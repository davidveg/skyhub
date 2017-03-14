defmodule  Skyhub.Helper do
import Ecto.Query
alias Skyhub.Repo
alias Skyhub.Image

  def struct_from_map(a_map, as: a_struct) do
    # Find the keys within the map
    keys = Map.keys(a_struct)
             |> Enum.filter(fn x -> x != :__struct__ end)
    # Process map, checking for both string / atom keys
    processed_map =
     for key <- keys, into: %{} do
         value = Map.get(a_map, key) || Map.get(a_map, to_string(key))
         {key, value}
       end
    a_struct = Map.merge(a_struct, processed_map)
    a_struct
  end

  def check_existence(params) do
     [0] == Repo.all(from i in Image, where: i.name == ^params[:name], select: count(i.id))
  end

end
