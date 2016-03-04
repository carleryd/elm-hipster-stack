alias GraphQL.Type.List
import RethinkDB.Query, only: [table: 1]

defmodule App.Query.Posts do
  def get do
    %{
      type: %List{ofType: App.Type.Post.get},
      resolve: fn (_, _args, _) ->
        table("posts")
        |> DB.run
        |> DB.handle_graphql_resp
      end
    }
  end
end
