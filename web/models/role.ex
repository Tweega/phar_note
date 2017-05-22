# web/models/role.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Role do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  schema "user_roles" do
    field :role_name,    :string
    field :role_desc,    :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:role_name, :role_desc])
      |> unique_constraint(:role_name)
  end

  def sorted(query) do
    from u in query,
    order_by: [asc: u.role_name]
  end
end
