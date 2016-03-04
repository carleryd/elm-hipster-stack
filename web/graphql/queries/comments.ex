alias GraphQL.Type.List
import RethinkDB.Query, only: [table: 1]

defmodule App.Query.Comments do
  def get do
    %{
      type: %List{ofType: App.Type.Comment.get},
      resolve: fn (_, _args, _) ->
        table("comments")
        |> DB.run
        |> DB.handle_graphql_resp
      end
    }
  end
end
