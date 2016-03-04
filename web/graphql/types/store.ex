defmodule App.Type.Store do

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType

  def get do
    %ObjectType{
      name: "Store",
      fields: %{
        links: App.Query.Link.get,
      }
    }
  end
end
