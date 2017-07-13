# web/models/location.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Location do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "locations" do

    field :location_name, :string
    field :location_desc, :string
    field :level, :integer

    belongs_to :parent_location, PharNote.Location
    has_many :child_locations, PharNote.Location, foreign_key: :parent_location

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:location_name, :location_desc])
      |> unique_constraint(:location_name)
  end

  def changeset_update( location, params \\ :empty) do
       location
        |> Repo.preload(:users)
        |> cast(params, [:location_name, :location_desc])
        |> cast_assoc(:users)
  end

  def changeset_new( location, params \\ :empty) do
    #assuming here that new  location will not have any locations, which is probably not going to be the case
     location
        |> cast(params, [:location_name, :location_desc])
        |> unique_constraint(:location_name)
  end


  def sorted(query) do
    from u in query,
    order_by: [asc: u.location_name]
  end

  def with_users(query) do
    from u in query,
    preload: [:users]
  end

  def locations(query) do
    from u in query,
      select: map(u, [:id, :location_name, :location_desc])
  end
end
