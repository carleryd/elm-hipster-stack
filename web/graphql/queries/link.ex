defmodule App.Query.Link do
  alias GraphQL.Type.List
  import RethinkDB.Query, only: [table: 1]
  def get do
    %{
      type: %List{ofType: App.Type.Link.get},
      resolve: fn (_, _args, _) ->
        table("links")
        |> DB.run
        |> DB.handle_graphql_resp
      end
    }
  end
end
