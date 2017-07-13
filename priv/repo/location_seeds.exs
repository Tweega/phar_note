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
alias PharNote.Location
alias Ecto.Changeset


Repo.delete_all(Location)

# post = Ecto.Changeset.change(%Post{}, title: "Hello", body: "world")
# comment = Ecto.Changeset.change(%Comment{}, body: "Excellent!")
# post_with_comments = Ecto.Changeset.put_assoc(post, :comments, [comment])
# Repo.insert!(post_with_comments)
multiply = fn (x,y) -> x + y end
x = multiply.(2,3)
add_room = fn (room_struct, area) ->
    r = Repo.insert! (room_struct)  |> Repo.preload(:parent_location)
    cs = r
        |> Changeset.change
        |> Changeset.put_assoc(:parent_location, area)

    Repo.update! cs
end


area1 = Repo.insert! (%Location{ location_name: "Area Blue", location_desc: "Area Blue desc", level: 1 })
add_room.(%Location{ location_name: "Blue room 1", location_desc: "Blue room 1 desc", level: 2 }, area1)
add_room.(%Location{ location_name: "Blue room 2", location_desc: "Blue room 2 desc", level: 2 }, area1)
add_room.(%Location{ location_name: "Blue room 3", location_desc: "Blue room 3 desc", level: 2 }, area1)

area2 = Repo.insert! (%Location{ location_name: "Area Green", location_desc: "Area Green desc", level: 1 })
add_room.(%Location{ location_name: "Green room 1", location_desc: "Green room 1 desc", level: 2 }, area2)
add_room.(%Location{ location_name: "Green room 2", location_desc: "Green room 2 desc", level: 2 }, area2)
add_room.(%Location{ location_name: "Green room 3", location_desc: "Green room 3 desc", level: 2 }, area2)

area3 = Repo.insert! (%Location{ location_name: "Area Red", location_desc: "Area Red desc", level: 1 })
add_room.(%Location{ location_name: "Red room 1", location_desc: "Red room 1 desc", level: 2 }, area3)
add_room.(%Location{ location_name: "Red room 2", location_desc: "Red room 2 desc", level: 2 }, area3)
add_room.(%Location{ location_name: "Red room 3", location_desc: "Red room 3 desc", level: 2 }, area3)
add_room.(%Location{ location_name: "Red room 4", location_desc: "Red room 4 desc", level: 2 }, area3)



    # Repo.insert! %Location{ location_name: "Area Red", location_desc: "Area Red desc", level: 1}
    # Repo.insert! %Location{ location_name: "Red room 1", location_desc: "Red room 1 desc", level: 2}
    # Repo.insert! %Location{ location_name: "Red room 2", location_desc: "Red room 2 desc", level: 2 }
    #
    # Repo.insert! %Location{ location_name: "Area Green", location_desc: "Area Green desc", level: 1}
    # Repo.insert! %Location{ location_name: "Green room 1", location_desc: "Green room 1 desc", level: 2}
    # Repo.insert! %Location{ location_name: "Green room 2", location_desc: "Green room 2 desc", level: 2 }
    # Repo.insert! %Location{ location_name: "Green room 3", location_desc: "Green room 3 desc", level: 2 }

    # area1 = Ecto.Changeset.change(%Location{ location_name: "Area Blue", location_desc: "Area Blue desc", level: 1 })
    # room1 = Ecto.Changeset.change(%Location{ location_name: "Blue room 1", location_desc: "Blue room 1 desc", level: 2 })
    # area_with_room = Ecto.Changeset.put_assoc(area1, :child_locations, [room1], [foreign_key: :parent_location_id])
    # Repo.insert!(area_with_room)
