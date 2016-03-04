defmodule App.PublicSchema do

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Mutation
  alias GraphQL.Type.List

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
