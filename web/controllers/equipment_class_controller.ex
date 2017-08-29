defmodule PharNote.EquipmentClassesController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    equipment_class = index_data()
            #  |> Enum.map(fn(equipment_class) -> cleanup(equipment_class) end)
    json conn, equipment_class
  end

  def index_data() do
    data = PharNote.EquipmentClasses
     |> PharNote.EquipmentClasses.class_precision
     |> PharNote.EquipmentClasses.sorted
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.EquipmentClasses.sorted

  end

  def strip_precision_assocs(eq_class) do
    Enum.map(eq_class, fn ec ->
      #what I want back is a new list of roles

    #   equipment_precision object has:
    #       equipment -- each equipment item will have a precision (or perhaps none or a dummy one) - so this will return all equip of this precision
    #       equipment_classes -- a precision is for a class
    #       equipment_requirement --


      new_precisions = Enum.map(ec.equipment_precision, fn p ->
        %PharNote.EquipmentPrecision{ p | equipment: nil, equipment_classes: nil, equipment_requirement: []}
      end)
      %PharNote.EquipmentClasses{ec | equipment_precision: new_precisions}
    end)
  end

  def show(conn, %{"id" => id}) do
    equipment_class = Repo.get(PharNote.EquipmentClasses, String.to_integer(id))

    json conn_with_status(conn, equipment_class), equipment_class
  end


  def create(conn, params) do
    #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "equipment_class_roles" => "12,13, 15"}
    Logger.debug fn -> inspect(params) end
    changeset = PharNote.EquipmentClasses.changeset_new(%PharNote.EquipmentClasses{}, params)
    case Repo.insert(changeset) do
      {:ok, equipment_class} ->
        cs = PharNote.EquipmentClasses.changesetx(equipment_class, params)
        case Repo.update(cs) do
          {:ok, newEquipmentClass} ->
            u2 = %PharNote.EquipmentClasses{ newEquipmentClass | equipment_precision: []}  #or nil - can get away with this only because we don't use the return data
            json conn |> put_status(:created), u2 #why not just return equipment_class
          {:error, _changeset} ->
            json conn |> put_status(:bad_request), %{errors: ["unable to create equipment_class 1"]}
        end
      {:error, _changeset} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to create equipment_class"]}
    end
  end

  def update(conn, %{"id" => id} = params) do
    equipment_class = Repo.get(PharNote.EquipmentClasses, id)
    if equipment_class do
      perform_update(conn, equipment_class, params)
    else
      json conn |> put_status(:not_found), %{errors:   ["invalid equipment_class"]}
    end
  end

  defp perform_update(conn, equipment_class, params) do
    changeset = PharNote.EquipmentClasses.changesety(equipment_class, params)
    case Repo.update(changeset) do
      {:ok, equipment_class} ->
        p2 = hd(strip_precision_assocs([equipment_class])) #- why pass as an array only to un-array it?
        #Logger.debug fn -> inspect(equipment_class) end
        json conn |> put_status(:ok), p2
      {:error, _result} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to update equipment_class"]}
    end
  end

  def delete(conn, %{"id" => id}) do
    equipment_class = Repo.get(PharNote.EquipmentClasses, id)
    if equipment_class do
      Repo.delete(equipment_class)
      u2 = %PharNote.EquipmentClasses{ equipment_class | equipment_precision: []}  #or nil - why are we returning an empty eq clasS?
      json conn |> put_status(:accepted), u2
    else
      json conn |> put_status(:not_found), %{errors: ["invalid equipment_class"]}
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



#  defp cleanup(equipment_class) do
#    Map.drop(equipment_class, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
