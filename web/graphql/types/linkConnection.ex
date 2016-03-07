defmodule App.Type.LinkConnection do
  alias GraphQL.Type.List
  alias GraphQL.Relay.Connection

  def get do
    %{
      name: "Link",
      node_type: App.Type.Link.get,
      edge_fields: %{},
      connection_fields: %{},
      resolve_node: nil,
      resolve_cursor: nil
    } |> Connection.new
  end
end
