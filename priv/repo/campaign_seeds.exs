# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PharNote.Repo.insert!(%PharNote.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PharNote.Repo
alias PharNote.Campaign
alias PharNote.Product
alias PharNote.Location



Repo.delete_all(Campaign)

poly_product = Repo.get_by(Product, product_name: "Polyjuice")
poly_location = Repo.get_by(Location, location_name: "Blue room 1")
{:ok, poly_planned_start, _offset} = DateTime.from_iso8601("2017-07-23T23:50:07Z")
{:ok, poly_planned_end, _offset} = DateTime.from_iso8601("2017-08-01T12:50:07Z")

#an equipment class represents a set of instructions. Equipment roles will link to this table.
# there may also be a context in which instructions are used.  So one set of instructions at productions start - another at production end.
#in syncade a class also represents a collection of attributes//processes
Repo.insert! %Campaign{ campaign_name: "Polyjuice campaign 1", campaign_desc: "First campaign to make polyjuice", order_number: "OrderPoly123", planned_start: poly_planned_start, planned_end: poly_planned_end, product_id: poly_product.id, location_id: poly_location.id}

love_product = Repo.get_by(Product, product_name: "LoveAnother")
love_location = Repo.get_by(Location, location_name: "Red room 1")
{:ok, love_planned_start, _offset} = DateTime.from_iso8601("2017-07-22T13:50:07Z")
{:ok, love_planned_end, _offset} = DateTime.from_iso8601("2017-08-01T12:50:07Z")

Repo.insert! %Campaign{ campaign_name: "LoveAnother campaign 1", campaign_desc: "First campaign to make LoveAnother", order_number: "LoveAnother123", planned_start: love_planned_start, planned_end: love_planned_end, product_id: love_product.id, location_id: love_location.id}

#IO.inspect(poly_planned_start)

##Time stuff

# iex(1)> Ecto.DateTime.utc
# #Ecto.DateTime<2016-12-25 14:47:07>
# iex(2)> Timex.add(Timex.now, Timex.Duration.from_days(1)) |> Ecto.DateTime.cast!
# #Ecto.DateTime<2016-12-26 14:47:08.996803>

# user_params = Map.put(user_params, "end_date", DateTime.utc_now)
# access_token_expires_at: {{2015, 12, 31}, {12, 00, 00}}
# http://learningelixir.joekain.com/custom-types-in-ecto/
