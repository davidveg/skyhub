defmodule Skyhub.ExtractMap do

    def extract_from_body(map) do
      {:ok, body} = map
      extract_map(body)
    end

    def extract_map(body) do
      urls = get_in(body, ["images"])
      urls
    end
end
