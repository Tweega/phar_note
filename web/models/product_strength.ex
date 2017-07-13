# web/models/product.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.ProductStrength do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "product_strengths" do

    field :strength, :string

    belongs_to :product, PharNote.Product

    timestamps()
  end


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:product_name, :product_desc])
      |> unique_constraint(:product_name)
  end

  def changeset_update( product, params \\ :empty) do
       product
        |> Repo.preload(:users)
        |> cast(params, [:product_name, :product_desc])
        |> cast_assoc(:users)
  end

  def changeset_new( product, params \\ :empty) do
    #assuming here that new  product will not have any products, which is probably not going to be the case
     product
        |> cast(params, [:product_name, :product_desc])
        |> unique_constraint(:product_name)
  end


  def sorted(query) do
    from u in query,
    order_by: [asc: u.product_name]
  end

  def with_users(query) do
    from u in query,
    preload: [:users]
  end

  def products(query) do
    from u in query,
      select: map(u, [:id, :product_name, :product_desc])
  end
end
