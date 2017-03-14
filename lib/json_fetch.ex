defmodule Skyhub.JSONFetch do

  def fetch do
    endpoint_to_consume
    |> HTTPoison.get
    |> handle_json
  end

  defp endpoint_to_consume do
    Application.get_env(:skyhub, :url_to_call)
  end

  def handle_json({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_json({_, %{status_code: _}}) do
    IO.puts "Something went wrong. Please check your internet connection"
  end
end
