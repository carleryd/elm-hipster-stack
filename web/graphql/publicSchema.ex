defmodule App.PublicSchema do

  import List , only: [first: 1]
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.List
  alias GraphQL.Type.NonNull
  alias GraphQL.Type.String
  alias GraphQL.Relay.Mutation
  alias RethinkDB.Query


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
      },
      mutation: %ObjectType{
        name: "Mutation",
        fields: %{
          createLink: Mutation.new(%{
            name: "createLink",
            input_fields: %{
              title: %{type: %NonNull{ofType: %String{}}},
              url: %{type: %NonNull{ofType: %String{}}}
            },
            output_fields: %{
              link: %{
                type: App.Type.Link.get,
                resolve: fn (obj, _args, _info) ->
                  App.Query.Link.get_link(first(obj[:generated_keys]))
                end
              }
            },
            mutate_and_get_payload: fn(input, _info) ->
              Query.table("links")
                |> Query.insert(%{title: input["title"], url: input["url"]})
                |> DB.run
                |> DB.handle_graphql_resp
            end
          })
        }
      }
    }
  end
end
