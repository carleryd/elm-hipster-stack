defmodule App.Post do
  use App.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    belongs_to :user, App.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
  end
end
