defmodule App.Type.Author do
  @type_string %{type: %GraphQL.Type.String{}}
  alias GraphQL.Type.ObjectType

  def get do
    %ObjectType{
      name: 'Author',
      fields: %{
        id: @type_string,
        name: @type_string
      }
    }
  end
end
