defmodule App.Query.Link do
  alias GraphQL.Type.List
  import RethinkDB.Query, only: [table: 1]
  def get do
    %{
      type: %List{ofType: App.Type.Link.get},
      resolve: fn (_, args, _) ->
        table("links")
        |> DB.limit(args.first)
        |> DB.run
        |> DB.handle_graphql_resp
      end
    }
  end
end
