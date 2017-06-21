defmodule App.PageControllerTest do
  use App.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Elm Hipster Stack"
  end
end
