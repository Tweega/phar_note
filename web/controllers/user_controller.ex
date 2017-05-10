defmodule PharNote.UserController do
  use PharNote.Web, :controller

  def index(conn, _params) do
    users = Repo.all(PharNote.User)
            #  |> Enum.map(fn(user) -> cleanup(user) end)
    json conn, users
  end

#  defp cleanup(user) do
#    Map.drop(user, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
