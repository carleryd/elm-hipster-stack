defmodule MyApp.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: MyApp.Repo
 
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :posts, list_of(:post), resolve: assoc(:posts)
  end
 
  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
    field :user, :user, resolve: assoc(:user)
  end
end
