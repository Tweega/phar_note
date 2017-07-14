# web/models/role.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Role do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "role" do
    field :role_name,    :string
    field :role_desc,    :string

    many_to_many :users, PharNote.User,
      [ join_through: "user_role",
        on_replace: :delete,
        on_delete: :delete_all
      ]

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

  def changeset_update( role, params \\ :empty) do
       role
        |> Repo.preload(:users)
        |> cast(params, [:role_name, :role_desc])
        |> cast_assoc(:users)
  end

  def changeset_new( role, params \\ :empty) do
    #assuming here that new  role will not have any roles, which is probably not going to be the case
     role
        |> cast(params, [:role_name, :role_desc])
        |> unique_constraint(:role_name)
  end


  def sorted(query) do
    from u in query,
    order_by: [asc: u.role_name]
  end

  def with_users(query) do
    from u in query,
    preload: [:users]
  end

  def roles(query) do
    from u in query,
      select: map(u, [:id, :role_name, :role_desc])
  end
end
