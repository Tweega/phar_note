defmodule PharNote.LocationController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    location = index_data()
            #  |> Enum.map(fn(location) -> cleanup(location) end)
    json conn, location
  end

  def index_data() do
    data = PharNote.Location
     |> PharNote.Location.test_join
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.Location.sorted

  end


  def show(conn, %{"id" => id}) do
    location = Repo.get(PharNote.Location, String.to_integer(id))

    json conn_with_status(conn, location), location
  end

  # def create(conn, params) do
  #
  #   #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "location_roles" => "12,13, 15"}
  #
  #   changeset = PharNote.Location.changeset_new(%PharNote.Location{}, params)
  #   case Repo.insert(changeset) do
  #     {:ok, location} ->
  #       cs = PharNote.Location.changesetx(location, params)
  #       case Repo.update(cs) do
  #         {:ok, newLocation} ->
  #           #strip out the location_roles field - either that or do a cast_assoc on it
  #           u2 = %PharNote.Location{ newLocation | location_roles: []}  #or nil
  #           json conn |> put_status(:created), u2 #why not just return location
  #         {:error, _changeset} ->
  #           json conn |> put_status(:bad_request), %{errors: ["unable to create location 1"]}
  #       end
  #     {:error, _changeset} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to create location"]}
  #   end
  # end
  #
  # def update(conn, %{"id" => id} = params) do
  #   location = Repo.get(PharNote.Location, id)
  #   if location do
  #     perform_update(conn, location, params)
  #   else
  #     json conn |> put_status(:not_found), %{errors:   ["invalid location"]}
  #   end
  # end
  #
  # defp perform_update(conn, location, params) do
  #   changeset = PharNote.Location.changesetx(location, params)
  #   case Repo.update(changeset) do
  #     {:ok, location} ->
  #       u2 = hd(strip_role_location([location]))
  #       json conn |> put_status(:ok), u2
  #     {:error, _result} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to update location"]}
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   location = Repo.get(PharNote.Location, id)
  #   if location do
  #     Repo.delete(location)
  #     u2 = %PharNote.Location{ location | location_roles: []}  #or nil
  #     json conn |> put_status(:accepted), u2
  #   else
  #     json conn |> put_status(:not_found), %{errors: ["invalid location"]}
  #   end
  # end

  defp conn_with_status(conn, nil) do
    conn
      |> put_status(:not_found)
  end

  defp conn_with_status(conn, _) do
    conn
      |> put_status(:ok)
  end



#  defp cleanup(location) do
#    Map.drop(location, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
