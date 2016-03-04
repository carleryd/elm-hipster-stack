defmodule App.PublicSchema do

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType

  def schema do
    %Schema{
      query: %ObjectType{
        name: "Query",
        fields: %{
          store: %{
            type: App.Type.Store.get,
            resolve: fn (doc, _args, _) ->
              %{}
            end
          }
        }
      }
    }
  end

end

defmodule App.Type.Store do

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType


  def get do
    %ObjectType{
      name: "Store",
      fields: %{
        authors: App.Query.Authors.get,
        comments: App.Query.Comments.get,
        posts: App.Query.Posts.get,
      }
    }
  end
end
