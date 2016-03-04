defmodule DB do
  use RethinkDB.Connection

  # database helpers

  def handle_graphql_resp(data) do
    data |> strip_wrapper |> convert_to_symbol_map
  end

  defp strip_wrapper(%{data: nil}), do: %{}
  defp strip_wrapper(%{data: doc}), do: doc
  defp strip_wrapper(_anything), do: %{}

  # temp needed for GraphQL resolve function
  defp convert_to_symbol_map(data) when is_list(data) do
    Enum.map(data, fn (doc) ->
      for {key, val} <- doc, into: %{}, do: {String.to_atom(key), val}
    end)
  end
  defp convert_to_symbol_map(doc) when is_map(doc) do
    for {key, val} <- doc, into: %{}, do: {String.to_atom(key), val}
  end
end
