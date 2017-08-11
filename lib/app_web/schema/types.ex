defmodule AppWeb.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo
 
  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
  end
end
