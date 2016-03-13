defmodule App.Type.Store do

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType

  alias GraphQL.Relay.Node
  alias GraphQL.Relay.Connection
  alias GraphQL.Relay.Mutation
  import RethinkDB.Query, only: [table: 1]
  alias RethinkDB.Query
  @type_string %{type: %GraphQL.Type.String{}}
  import RethinkDB.Lambda

  def get do
    %ObjectType{
      name: "Store",
      fields: %{
        id: %{
          type: %GraphQL.Type.String{},
          args: Connection.args,
          resolve: fn ( obj , args , _ctx) ->
            IO.inspect obj
            "Hack"
          end
        },
        linkConnection: %{
          type: App.Type.LinkConnection.get[:connection_type],
          args: Map.merge(Connection.args, %{query: @type_string}),
          resolve: fn ( _, args , _ctx) ->
            query = table("links")
              |> Query.filter( lambda fn(link) ->  Query.match(link[:url],args[:query]) end)
              |> Query.order_by(Query.desc("timestamp"))
              |> DB.run
              |> DB.handle_graphql_resp
          Connection.List.resolve(query, args)
            Connection.List.resolve(query, args)
          end
        }
      }
    }
  end
end
