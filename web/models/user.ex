# web/models/user.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.User do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "users" do
    field :first_name,    :string
    field :last_name,     :string
    field :email,         :string
    field :photo_url,     :string

    #if we want timestamps on user_role_user then we need a model for UserRole
    many_to_many :roles, PharNote.Role,
      [ join_through: "user_roles",
        on_replace: :delete,
        on_delete: :delete_all
      ]

    #field :gender, :integer
    #field :birth_date, Ecto.Date
    #field :location, :string
    #field :phone_number, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(user, params \\ :empty) do
    user
      |> cast(params, [:first_name, :last_name, :email, :photo_url, :user_roles])
      |> unique_constraint(:email)
  end

  def changeset_update(user, params \\ :empty) do
      user
        |> Repo.preload(:roles)
        |> cast(params, [:first_name, :last_name, :email, :photo_url, :roles])
        |> cast_assoc(:roles)
        |> unique_constraint(:email)
  end

  def changeset_new(user, params \\ :empty) do
    #assuming here that new user will not have any roles, which is probably not going to be the case
    user
      |> cast(params, [:first_name, :last_name, :email, :photo_url])
      |> unique_constraint(:email)
  end

  def sorted(query) do
    from u in query,
    order_by: [asc: u.last_name]
  end

  def with_roles(query) do
    from u in query,
    preload: [:roles]
  end

  def with_roles_flat(query) do
#    [{"Percy", "Spell Learner"}, {"George", "Spell Learner"},
#     {"Ginnie", "Spell Learner"}, {"Fred", "Spell Learner"},
#     {"Ron", "Spell Learner"},
#     {"Hermione", "Spell Learner"}, {"Hermione", "Prefect"}]

    from u in query,
      inner_join: r in assoc(u, :roles),
      select: {u.first_name, u.last_name, r.role_name}
  end


  def changesetx(user, params \\ %{}) do
    # struct
    # |> Ecto.Changeset.cast(params, [:title, :body])
    # |> Ecto.Changeset.put_assoc(:tags, parse_tags(params))

    user
      |> Repo.preload(:user_roles)
      |> cast(params, [:first_name, :last_name, :email, :photo_url])
      |> put_assoc(:user_roles, parse_roles(params))
      |> unique_constraint(:email)
  end

  defp parse_roles(params)  do
    (params["user_roles"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_tagx/1)
  end

  defp get_or_insert_tagx(roleID) do
    Repo.get(PharNote.Role, roleID)
  end


end
