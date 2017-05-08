defmodule PharNote.PageController do
  use PharNote.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
