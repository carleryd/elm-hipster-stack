import RethinkDB.Query, only: [table_create: 1, table_drop: 1, table: 1, insert: 2]

defmodule App.PageController do
  use App.Web, :controller

  def reset_db(conn, _params) do
    for table_name <- ["posts", "authors", "comments"] do
      table_drop(table_name) |> DB.run
      table_create(table_name) |> DB.run
    end

    insert_author(%{id: "a1", name: "Jane Doe"})
    insert_author(%{id: "a2", name: "Adam Brodzinski"})
    insert_author(%{id: "a3", name: "Leah Smith"})

    for i <- ["1", "2", "3", "4", "5"] do
      insert_post(%{
        id: "p#{i}",
        title: "Post Number #{i}",
        content: "#{i} How now brown cow",
        author_id: "a#{:random.uniform(3)}"
      })
      insert_comment(%{
        id: "c#{i}",
        post_id: "p#{i}",
        author_id: "a#{:random.uniform(3)}",
        text: "Test comment #{i}"
      })
    end

    text conn, "Database Reset"
  end


  def index(conn, _params) do
    render conn, "index.html"
  end


  defp insert_author(doc), do: table("authors") |> insert(doc) |> DB.run
  defp insert_comment(doc), do: table("comments") |> insert(doc) |> DB.run
  defp insert_post(doc), do: table("posts") |> insert(doc) |> DB.run
end
