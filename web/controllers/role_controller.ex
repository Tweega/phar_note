defmodule PharNote.RoleController do
  use PharNote.Web, :controller

  def index(conn, _params) do
    roles = index_data()
            #  |> Enum.map(fn(role) -> cleanup(role) end)
    json conn, roles
  end

  def role_data(conn, _params) do
    roles = PharNote.Role
    |> PharNote.Role.roles
    |> PharNote.Role.sorted
    |> Repo.all
    json conn, roles
  end


  def index_data() do
    roles = PharNote.Role
    |> PharNote.Role.with_users
    |> PharNote.Role.sorted
    |> Repo.all

    strip_user_roles(roles)
  end

  def strip_user_roles(roles) do
    Enum.map(roles, fn r ->
      #what I want back is a new list of users
      new_users = Enum.map(r.users, fn u ->
        %PharNote.User{ u | roles: nil}
      end)
      %PharNote.Role{r | users: new_users}
    end)
  end

  def show(conn, %{"id" => id}) do
    role = Repo.get(PharNote.Role, String.to_integer(id))

    json conn_with_status(conn, role), role
  end

  def create(conn, params) do
    changeset = PharNote.Role.changeset_new(%PharNote.Role{}, params)
    case Repo.insert(changeset) do
      {:ok, role} ->
        r2 = %PharNote.Role{ role | users: []}  #need to update to handle roles being sent at the same time
        json conn |> put_status(:created), r2
      {:error, _changeset} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to create role"]}
    end
  end

  def update(conn, %{"id" => id} = params) do
    role = Repo.get(PharNote.Role, id)
    if role do
      perform_update(conn, role, params)
    else
      json conn |> put_status(:not_found), %{errors: ["invalid role"]}
    end
  end

  defp perform_update(conn, role, params) do
    changeset = PharNote.Role.changeset_update(role, params)
    case Repo.update(changeset) do
      {:ok, role} ->
        r2 = hd(strip_user_roles([role]))
        json conn |> put_status(:ok), r2
      {:error, _result} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to update role"]}
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Repo.get(PharNote.Role, id)
    if role do
      Repo.delete(role)
      r2 = %PharNote.Role{ role | users: []}  #or nil
      json conn |> put_status(:accepted), r2
    else
      json conn |> put_status(:not_found), %{errors: ["invalid role"]}
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



#  defp cleanup(role) do
#    Map.drop(role, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
