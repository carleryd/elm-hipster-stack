alias GraphQL.Type.List
import RethinkDB.Query, only: [table: 1]

defmodule App.Query.Authors do
  def get do
    %{
      type: %List{ofType: App.Type.Author.get},
      resolve: fn (_, _args, _) ->
        table("authors")
        |> DB.run
        |> DB.handle_graphql_resp
      end
    }
  end
end
