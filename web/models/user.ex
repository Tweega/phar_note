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

    #field :gender, :integer
    #field :birth_date, Ecto.Date
    #field :location, :string
    #field :phone_number, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :gender, :birth_date, :location, :phone_number, :email, :headline, :picture])
    |> validate_required([:first_name, :last_name, :gender, :birth_date, :location, :phone_number, :email, :headline, :picture])
  end
end
