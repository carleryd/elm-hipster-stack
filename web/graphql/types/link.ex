
defmodule App.Type.Link do
  @type_string %{type: %GraphQL.Type.String{}}
  alias GraphQL.Type.ObjectType

  def get do
    %ObjectType{
        name: "Link",
        fields: %{
          id: @type_string,
          title: @type_string,
          url: @type_string
        }
      }
  end

end
