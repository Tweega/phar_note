defmodule PharNote.ProductController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    product = index_data()
            #  |> Enum.map(fn(product) -> cleanup(product) end)
    json conn, product
  end

  def index_data() do
    data = PharNote.Product
     |> PharNote.Product.test_preload_join
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.Product.sorted

  end


  def show(conn, %{"id" => id}) do
    product = Repo.get(PharNote.Product, String.to_integer(id))

    json conn_with_status(conn, product), product
  end

  # def create(conn, params) do
  #
  #   #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "product_roles" => "12,13, 15"}
  #
  #   changeset = PharNote.Product.changeset_new(%PharNote.Product{}, params)
  #   case Repo.insert(changeset) do
  #     {:ok, product} ->
  #       cs = PharNote.Product.changesetx(product, params)
  #       case Repo.update(cs) do
  #         {:ok, newProduct} ->
  #           #strip out the product_roles field - either that or do a cast_assoc on it
  #           u2 = %PharNote.Product{ newProduct | product_roles: []}  #or nil
  #           json conn |> put_status(:created), u2 #why not just return product
  #         {:error, _changeset} ->
  #           json conn |> put_status(:bad_request), %{errors: ["unable to create product 1"]}
  #       end
  #     {:error, _changeset} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to create product"]}
  #   end
  # end
  #
  # def update(conn, %{"id" => id} = params) do
  #   product = Repo.get(PharNote.Product, id)
  #   if product do
  #     perform_update(conn, product, params)
  #   else
  #     json conn |> put_status(:not_found), %{errors:   ["invalid product"]}
  #   end
  # end
  #
  # defp perform_update(conn, product, params) do
  #   changeset = PharNote.Product.changesetx(product, params)
  #   case Repo.update(changeset) do
  #     {:ok, product} ->
  #       u2 = hd(strip_role_product([product]))
  #       json conn |> put_status(:ok), u2
  #     {:error, _result} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to update product"]}
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   product = Repo.get(PharNote.Product, id)
  #   if product do
  #     Repo.delete(product)
  #     u2 = %PharNote.Product{ product | product_roles: []}  #or nil
  #     json conn |> put_status(:accepted), u2
  #   else
  #     json conn |> put_status(:not_found), %{errors: ["invalid product"]}
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



#  defp cleanup(product) do
#    Map.drop(product, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
