defmodule PharNote.EquipmentPrecisionController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    equipment_precision = index_data()
            #  |> Enum.map(fn(equipment_precision) -> cleanup(equipment_precision) end)
    json conn, equipment_precision
  end

  def index_data() do
    data = PharNote.EquipmentPrecision
     |> PharNote.EquipmentPrecision.precision
     #|> PharNote.EquipmentPrecision.sorted
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.EquipmentPrecision.sorted

  end

  def show(conn, %{"id" => id}) do
    equipment_precision = Repo.get(PharNote.EquipmentPrecision, String.to_integer(id))

    json conn_with_status(conn, equipment_precision), equipment_precision
  end

  # def create(conn, params) do
  #
  #   #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "equipment_precision_roles" => "12,13, 15"}
  #
  #   changeset = PharNote.EquipmentPrecision.changeset_new(%PharNote.EquipmentPrecision{}, params)
  #   case Repo.insert(changeset) do
  #     {:ok, equipment_precision} ->
  #       cs = PharNote.EquipmentPrecision.changesetx(equipment_precision, params)
  #       case Repo.update(cs) do
  #         {:ok, newEquipmentPrecision} ->
  #           #strip out the equipment_precision_roles field - either that or do a cast_assoc on it
  #           u2 = %PharNote.EquipmentPrecision{ newEquipmentPrecision | equipment_precision_roles: []}  #or nil
  #           json conn |> put_status(:created), u2 #why not just return equipment_precision
  #         {:error, _changeset} ->
  #           json conn |> put_status(:bad_request), %{errors: ["unable to create equipment_precision 1"]}
  #       end
  #     {:error, _changeset} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to create equipment_precision"]}
  #   end
  # end
  #
  # def update(conn, %{"id" => id} = params) do
  #   equipment_precision = Repo.get(PharNote.EquipmentPrecision, id)
  #   if equipment_precision do
  #     perform_update(conn, equipment_precision, params)
  #   else
  #     json conn |> put_status(:not_found), %{errors:   ["invalid equipment_precision"]}
  #   end
  # end
  #
  # defp perform_update(conn, equipment_precision, params) do
  #   changeset = PharNote.EquipmentPrecision.changesetx(equipment_precision, params)
  #   case Repo.update(changeset) do
  #     {:ok, equipment_precision} ->
  #       u2 = hd(strip_role_equipment_precision([equipment_precision]))
  #       json conn |> put_status(:ok), u2
  #     {:error, _result} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to update equipment_precision"]}
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   equipment_precision = Repo.get(PharNote.EquipmentPrecision, id)
  #   if equipment_precision do
  #     Repo.delete(equipment_precision)
  #     u2 = %PharNote.EquipmentPrecision{ equipment_precision | equipment_precision_roles: []}  #or nil
  #     json conn |> put_status(:accepted), u2
  #   else
  #     json conn |> put_status(:not_found), %{errors: ["invalid equipment_precision"]}
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



#  defp cleanup(equipment_precision) do
#    Map.drop(equipment_precision, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
