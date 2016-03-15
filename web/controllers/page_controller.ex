import RethinkDB.Query, only: [table_create: 1, table_drop: 1, table: 1, insert: 2]

defmodule App.PageController do
  use App.Web, :controller

  def reset_db(conn, _params) do
    for table_name <- ["links"] do
      table_drop(table_name) |> DB.run
      table_create(table_name) |> DB.run
    end

    insert_link(%{ title: "herp", url: "derp", timestamp: TimeHelper.currentTime})

    text conn, "Database Reset"
  end


  def index(conn, _params) do
    render conn, "app.html"
  end


  defp insert_link(doc), do: table("links") |> insert(doc) |> DB.run
end
