defmodule PharNote.EquipmentController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    equipment = index_data()
            #  |> Enum.map(fn(equipment) -> cleanup(equipment) end)
    json conn, equipment
  end

  def index_data() do
    data = PharNote.Equipment
     |> PharNote.Equipment.test_join
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.Equipment.sorted

  end


  def strip_equip(equipment) do
    # Enum.map(equipment, fn u ->
    #   #what I want back is a new list of roles
    #   new_roles = Enum.map(u.equipment_roles, fn r ->
    #     %PharNote.Role{ r | equipment: []}
    #   end)
    #   %PharNote.Equipment{u | equipment_roles: new_roles}
    # end)
    equipment
  end

  def show(conn, %{"id" => id}) do
    equipment = Repo.get(PharNote.Equipment, String.to_integer(id))

    json conn_with_status(conn, equipment), equipment
  end

  # def create(conn, params) do
  #
  #   #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "equipment_roles" => "12,13, 15"}
  #
  #   changeset = PharNote.Equipment.changeset_new(%PharNote.Equipment{}, params)
  #   case Repo.insert(changeset) do
  #     {:ok, equipment} ->
  #       cs = PharNote.Equipment.changesetx(equipment, params)
  #       case Repo.update(cs) do
  #         {:ok, newEquipment} ->
  #           #strip out the equipment_roles field - either that or do a cast_assoc on it
  #           u2 = %PharNote.Equipment{ newEquipment | equipment_roles: []}  #or nil
  #           json conn |> put_status(:created), u2 #why not just return equipment
  #         {:error, _changeset} ->
  #           json conn |> put_status(:bad_request), %{errors: ["unable to create equipment 1"]}
  #       end
  #     {:error, _changeset} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to create equipment"]}
  #   end
  # end
  #
  # def update(conn, %{"id" => id} = params) do
  #   equipment = Repo.get(PharNote.Equipment, id)
  #   if equipment do
  #     perform_update(conn, equipment, params)
  #   else
  #     json conn |> put_status(:not_found), %{errors:   ["invalid equipment"]}
  #   end
  # end
  #
  # defp perform_update(conn, equipment, params) do
  #   changeset = PharNote.Equipment.changesetx(equipment, params)
  #   case Repo.update(changeset) do
  #     {:ok, equipment} ->
  #       u2 = hd(strip_role_equipment([equipment]))
  #       json conn |> put_status(:ok), u2
  #     {:error, _result} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to update equipment"]}
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   equipment = Repo.get(PharNote.Equipment, id)
  #   if equipment do
  #     Repo.delete(equipment)
  #     u2 = %PharNote.Equipment{ equipment | equipment_roles: []}  #or nil
  #     json conn |> put_status(:accepted), u2
  #   else
  #     json conn |> put_status(:not_found), %{errors: ["invalid equipment"]}
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



#  defp cleanup(equipment) do
#    Map.drop(equipment, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
