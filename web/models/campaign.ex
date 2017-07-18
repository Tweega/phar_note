# web/models/equipment.ex
# this is, in effect, the query and the client side data model.

defmodule PharNote.Campaign do
  use PharNote.Web, :model

  @derive {Poison.Encoder, except: [:__meta__, :inserted_at, :updated_at]} # when encoding json do not include these fields

  alias PharNote.Repo #this is essentially an indirect load of Ecto.Repo


  schema "campaign" do
    field :campaign_name,    :string
    field :campaign_desc,    :string
    field :order_number,    :string

    field :planned_start, :utc_datetime
    field :planned_end, :utc_datetime
    field :actual_start, :utc_datetime
    field :actual_end, :utc_datetime

    belongs_to :product, PharNote.Product
    belongs_to :location, PharNote.Location
    #belongs_to :current_state, PharNote.ProcessState

    timestamps()

  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(equipment, params \\ :empty) do
    equipment
      |> cast(params, [:campaign_name, :campaign_desc, :order_number])

  end





end
