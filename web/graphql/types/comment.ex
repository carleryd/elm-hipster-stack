import RethinkDB.Query, only: [table: 1, get: 2]
alias GraphQL.Type.ObjectType


defmodule App.Type.Comment do
  @type_string %{type: %GraphQL.Type.String{}}

  def get do
    %ObjectType{
      name: "Comment",
      description: "Blog post comment",
      fields: %{
        id: @type_string,
        text: @type_string,
        post_id: @type_string,
        author_id: @type_string,
        author: %{
          type: App.Type.Author.get,
          resolve: fn (doc, _args, _) ->
            table("authors")
            |> get(doc.author_id)
            |> DB.run
            |> DB.handle_graphql_resp
          end
        }
      }
    }
  end
end
