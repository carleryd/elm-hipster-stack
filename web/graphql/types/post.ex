alias GraphQL.Type.List
import RethinkDB.Query, only: [table: 1, get: 2, filter: 2]

defmodule App.Type.Post do
  @type_string %{type: %GraphQL.Type.String{}}

  def get do
    %GraphQL.Type.ObjectType{
      name: "Post",
      fields: %{
        id: @type_string,
        title: @type_string,
        content: @type_string,
        author: %{
          type: App.Type.Author.get,
          resolve: fn (doc, _args, _) ->
            table("authors")
            |> get(doc.author_id)
            |> DB.run
            |> DB.handle_graphql_resp
          end
        },
        comments: %{
          type: %List{ofType: App.Type.Comment.get},
          resolve: fn (doc, _args, _) ->
            # note, using get_all with index is faster than filter
            table("comments")
            |> filter(%{post_id: doc.id})
            |> DB.run
            |> DB.handle_graphql_resp
          end
        }
      }
    }
  end
end
