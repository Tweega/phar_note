defmodule PharNote.ProductStrengthController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    product_strength = index_data()
            #  |> Enum.map(fn(product_strength) -> cleanup(product_strength) end)
    json conn, product_strength
  end

  def index_data() do
    data = PharNote.ProductStrength
     |> PharNote.ProductStrength.test_map
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.ProductStrength.sorted

  end


  def show(conn, %{"id" => id}) do
    product_strength = Repo.get(PharNote.ProductStrength, String.to_integer(id))

    json conn_with_status(conn, product_strength), product_strength
  end

  # def create(conn, params) do
  #
  #   #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "product_strength_roles" => "12,13, 15"}
  #
  #   changeset = PharNote.ProductStrength.changeset_new(%PharNote.ProductStrength{}, params)
  #   case Repo.insert(changeset) do
  #     {:ok, product_strength} ->
  #       cs = PharNote.ProductStrength.changesetx(product_strength, params)
  #       case Repo.update(cs) do
  #         {:ok, newProductStrength} ->
  #           #strip out the product_strength_roles field - either that or do a cast_assoc on it
  #           u2 = %PharNote.ProductStrength{ newProductStrength | product_strength_roles: []}  #or nil
  #           json conn |> put_status(:created), u2 #why not just return product_strength
  #         {:error, _changeset} ->
  #           json conn |> put_status(:bad_request), %{errors: ["unable to create product_strength 1"]}
  #       end
  #     {:error, _changeset} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to create product_strength"]}
  #   end
  # end
  #
  # def update(conn, %{"id" => id} = params) do
  #   product_strength = Repo.get(PharNote.ProductStrength, id)
  #   if product_strength do
  #     perform_update(conn, product_strength, params)
  #   else
  #     json conn |> put_status(:not_found), %{errors:   ["invalid product_strength"]}
  #   end
  # end
  #
  # defp perform_update(conn, product_strength, params) do
  #   changeset = PharNote.ProductStrength.changesetx(product_strength, params)
  #   case Repo.update(changeset) do
  #     {:ok, product_strength} ->
  #       u2 = hd(strip_role_product_strength([product_strength]))
  #       json conn |> put_status(:ok), u2
  #     {:error, _result} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to update product_strength"]}
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   product_strength = Repo.get(PharNote.ProductStrength, id)
  #   if product_strength do
  #     Repo.delete(product_strength)
  #     u2 = %PharNote.ProductStrength{ product_strength | product_strength_roles: []}  #or nil
  #     json conn |> put_status(:accepted), u2
  #   else
  #     json conn |> put_status(:not_found), %{errors: ["invalid product_strength"]}
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



#  defp cleanup(product_strength) do
#    Map.drop(product_strength, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
