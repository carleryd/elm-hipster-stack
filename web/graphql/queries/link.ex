defmodule App.Query.Link do
  alias GraphQL.Type.List
  import RethinkDB.Query, only: [table: 1]
  alias RethinkDB.Query
  def get do
    %{
      type: %List{ofType: App.Type.Link.get},
      resolve: fn (_, args, _) ->
        table("links")
        |> Query.limit(args.first)
        |> DB.run
        |> DB.handle_graphql_resp
      end
    }
  end

  def get_from_id(id) do
    table("links")
    |> Query.get(id)
    |> DB.run
    |> DB.handle_graphql_resp
  end
end
