defmodule Mix.Tasks.CreateSchema do
  use Mix.Task
  import GraphQL
  import App.PublicSchema
  import Poison

  def run(args) do
    response = GraphQL.execute(App.PublicSchema.schema, GraphQL.Type.Introspection.query)
    case response do
      {:ok, schema} ->
        json = Poison.encode!(schema)
        File.write("./lib/babel-relay/schema.json", json)
      {:error, reason} ->
        IO.inspect "schema could not be created because #{reason}"
      _other ->
        IO.inspect "unknown error while createing schema"
    end
  end
end
