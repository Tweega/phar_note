defmodule PharNote.UserController do
  use PharNote.Web, :controller

  def index(conn, _params) do
    users = PharNote.User
    |> PharNote.User.with_roles
    |> PharNote.User.sorted
    |> Repo.all
            #  |> Enum.map(fn(user) -> cleanup(user) end)
    json conn, users
  end


  def show(conn, %{"id" => id}) do
    user = Repo.get(PharNote.User, String.to_integer(id))

    json conn_with_status(conn, user), user
  end

  def create(conn, params) do
    changeset = PharNote.User.changeset(%PharNote.User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        json conn |> put_status(:created), user
      {:error, _changeset} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to create user"]}
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Repo.get(PharNote.User, id)
    if user do
      perform_update(conn, user, params)
    else
      json conn |> put_status(:not_found), %{errors: ["invalid user"]}
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(PharNote.User, id)
    if user do
      Repo.delete(user)
      json conn |> put_status(:accepted), user
    else
      json conn |> put_status(:not_found), %{errors: ["invalid user"]}
    end
  end

  defp perform_update(conn, user, params) do
    changeset = PharNote.User.changeset(user, params)
    case Repo.update(changeset) do
      {:ok, user} ->
        json conn |> put_status(:ok), user
      {:error, _result} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to update user"]}
    end
  end

  defp conn_with_status(conn, nil) do
    conn
      |> put_status(:not_found)
  end

  defp conn_with_status(conn, _) do
    conn
      |> put_status(:ok)
  end



#  defp cleanup(user) do
#    Map.drop(user, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
