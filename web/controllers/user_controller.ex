defmodule PharNote.UserController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    users = index_data()
            #  |> Enum.map(fn(user) -> cleanup(user) end)
    json conn, users
  end

  def index_data() do
    data = PharNote.User
     |> PharNote.User.with_roles
     |> PharNote.User.sorted
     |> Repo.all

    strip_role_users(data)

  end

  def strip_role_users(users) do
    Enum.map(users, fn u ->
      #what I want back is a new list of roles
      new_roles = Enum.map(u.user_roles, fn r ->
        %PharNote.Role{ r | users: []}
      end)
      %PharNote.User{u | user_roles: new_roles}
    end)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(PharNote.User, String.to_integer(id))

    json conn_with_status(conn, user), user
  end

  def create(conn, params) do

    #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "user_roles" => "12,13, 15"}

    changeset = PharNote.User.changeset_new(%PharNote.User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        Logger.debug("helloo there" )
        Logger.debug(fn -> inspect (user) end)
        cs = PharNote.User.changesetx(user, params)
        Logger.debug(fn -> inspect (cs) end)
        case Repo.update(cs) do
          {:ok, newUser} ->
            Logger.debug(fn -> inspect (newUser) end)
            #strip out the user_roles field - either that or do a cast_assoc on it
            u2 = %PharNote.User{ newUser | user_roles: []}  #or nil
            json conn |> put_status(:created), u2 #why not just return user
          {:error, _changeset} ->
            json conn |> put_status(:bad_request), %{errors: ["unable to create user 1"]}
        end
      {:error, _changeset} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to create user"]}
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Repo.get(PharNote.User, id)
    if user do
      perform_update(conn, user, params)
    else
      json conn |> put_status(:not_found), %{errors:   ["invalid user"]}
    end
  end

  defp perform_update(conn, user, params) do
    changeset = PharNote.User.changeset_update(user, params)
    case Repo.update(changeset) do
      {:ok, user} ->
        u2 = hd(strip_role_users([user]))
        json conn |> put_status(:ok), u2
      {:error, _result} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to update user"]}
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(PharNote.User, id)
    if user do
      Repo.delete(user)
      u2 = %PharNote.User{ user | user_roles: []}  #or nil
      json conn |> put_status(:accepted), u2
    else
      json conn |> put_status(:not_found), %{errors: ["invalid user"]}
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
