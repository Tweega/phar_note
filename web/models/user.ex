# web/models/user.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.User do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  schema "users" do
    field :first_name,    :string
    field :last_name,     :string
    field :email,         :string
    field :photo_url,     :string

    many_to_many :user_roles, PharNote.Role, join_through: "user_roles_user"  #if we want timestamps on user_role_user then we need a model for UserRole

    #field :gender, :integer
    #field :birth_date, Ecto.Date
    #field :location, :string
    #field :phone_number, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:first_name, :last_name, :email, :photo_url, :user_roles])
      |> unique_constraint(:email)
  end

  def sorted(query) do
    from u in query,
    order_by: [desc: u.last_name]
  end

  def with_roles(query) do
    from u in query,
    preload: [:user_roles]
  end

  def with_roles_flat(query) do
#    [{"Percy", "Spell Learner"}, {"George", "Spell Learner"},
#     {"Ginnie", "Spell Learner"}, {"Fred", "Spell Learner"},
#     {"Ron", "Spell Learner"},
#     {"Hermione", "Spell Learner"}, {"Hermione", "Prefect"}]

    from u in query,
      inner_join: r in assoc(u, :user_roles),
      select: {u.first_name, u.last_name, r.role_name}
  end
end
