defmodule App.PublicSchema do

  import List , only: [first: 1]
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.List
  alias GraphQL.Type.NonNull
  alias GraphQL.Type.String
  alias GraphQL.Relay.Mutation
  alias RethinkDB.Query
  alias GraphQL.Relay.Connection
  @type_string %{type: %GraphQL.Type.String{}}
  use Timex
  alias GraphQL.Relay.Node

  def node_interface do
    Node.define_interface(fn(obj) ->
      IO.puts "define_interface"
      IO.inspect obj
      case obj do
        %{text: _text} ->
          App.Type.Store.get
        _ ->
          App.Type.Store.get
      end
    end)
  end

  def node_field do
    Node.define_field(node_interface, fn (_item, args, _ctx) ->
      [type, id] = Node.from_global_id(args[:id])
      IO.puts "This is the node_field"
      IO.inspect type
      IO.inspect id
      case type do
        "Store" ->
          %{}
        _ ->
          %{}
      end
    end)
  end

  def schema do
    %Schema{
      query: %ObjectType{
        name: "Query",
        fields: %{
          node: node_field,
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
            name: "CreateLink",
            input_fields: %{
              title: %{type: %NonNull{ofType: %String{}}},
              url: %{type: %NonNull{ofType: %String{}}}
            },
            output_fields: %{
              linkEdge: %{
                type: App.Type.LinkConnection.get[:edge_type],
                resolve: fn (obj, _args, _info) ->
                  %{
                    node: App.Query.Link.get_from_id(first(obj[:generated_keys])),
                    cursor: first(obj[:generated_keys])
                  }
                end
              },
              store: %{
                type: App.Type.Store.get,
                resolve: fn (obj, _args, _info) ->
                end
              }
            },
            mutate_and_get_payload: fn(input, _info) ->
              Query.table("links")
                |> Query.insert(
                  %{
                    title: input["title"],
                    url: input["url"],
                    timestamp: currentTime
                    })
                |> DB.run
                |> DB.handle_graphql_resp
            end
          })
        }
      }
    }
  end

  def currentTime do
    timestamp = Timex.format(DateTime.now, "{ISO:Extended}")
    case timestamp do
      {:ok, iso} ->
        iso
      {:error, reason} ->
        IO.inspect "schema could not be created because #{reason}"
      _other ->
        IO.inspect "unknown error while creating timestamp"
    end
  end
end
