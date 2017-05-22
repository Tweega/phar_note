defmodule PharNote.RoleController do
  use PharNote.Web, :controller

  def index(conn, _params) do
    roles = PharNote.Role
    |> PharNote.Role.sorted
    |> Repo.all
            #  |> Enum.map(fn(role) -> cleanup(role) end)
    json conn, roles
  end


  def show(conn, %{"id" => id}) do
    role = Repo.get(PharNote.Role, String.to_integer(id))

    json conn_with_status(conn, role), role
  end

  def create(conn, params) do
    changeset = PharNote.Role.changeset(%PharNote.Role{}, params)
    case Repo.insert(changeset) do
      {:ok, role} ->
        json conn |> put_status(:created), role
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

  def delete(conn, %{"id" => id}) do
    role = Repo.get(PharNote.Role, id)
    if role do
      Repo.delete(role)
      json conn |> put_status(:accepted), role
    else
      json conn |> put_status(:not_found), %{errors: ["invalid role"]}
    end
  end

  defp perform_update(conn, role, params) do
    changeset = PharNote.Role.changeset(role, params)
    case Repo.update(changeset) do
      {:ok, role} ->
        json conn |> put_status(:ok), role
      {:error, _result} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to update role"]}
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
