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
alias PharNote.User

Repo.delete_all("user_roles")
Repo.delete_all(User)


Repo.insert! %User{ first_name: "Harry", last_name: "Potter", email: "hp@hogwarts.wiz", photo_url: "images/HP/harrypotter.jpg" }
Repo.insert! %User{ first_name: "Hermione", last_name: "Granger", email: "hg@hogwarts.wiz", photo_url: "images/HP/hermione.jpg" }
Repo.insert! %User{ first_name: "Ron", last_name: "Weasley", email: "rw@hogwarts.wiz", photo_url: "images/HP/ron.jpg" }
Repo.insert! %User{ first_name: "Draco", last_name: "Malfoy", email: "hp@hogwarts.wiz", photo_url: "images/HP/draco.jpg" }
Repo.insert! %User{ first_name: "Cedric", last_name: "diggory", email: "hp@hogwarts.wiz", photo_url: "images/HP/cedricdiggory.jpg" }
Repo.insert! %User{ first_name: "Neville", last_name: "Longbottom", email: "hp@hogwarts.wiz", photo_url: "images/HP/neville.jpg" }
Repo.insert! %User{ first_name: "Rubeus", last_name: "Hagrid", email: "hp@hogwarts.wiz", photo_url: "images/HP/rubeus.jpg" }


Repo.insert! %User{ first_name: "Oliver", last_name: "wood", email: "ow@hogwarts.wiz", photo_url: "images/HP/oloverwood.jpg" }
Repo.insert! %User{ first_name: "Ginny", last_name: "Weasley", email: "gw@hogwarts.wiz", photo_url: "images/HP/ginny.jpg" }
Repo.insert! %User{ first_name: "Luna", last_name: "Lovegood", email: "lg@hogwarts.wiz", photo_url: "images/HP/luna.jpg" }
Repo.insert! %User{ first_name: "Percy", last_name: "Weasley", email: "pw@hogwarts.wiz", photo_url: "images/HP/percy.jpg" }
Repo.insert! %User{ first_name: "Sirius", last_name: "Black", email: "sb@hogwarts.wiz", photo_url: "images/HP/sirius.jpg" }
Repo.insert! %User{ first_name: "Seamus", last_name: "Finnigan", email: "sf@hogwarts.wiz", photo_url: "images/HP/seamusfinnigan.jpg" }
Repo.insert! %User{ first_name: "Nymphadora", last_name: "Tonks", email: "nt@hogwarts.wiz", photo_url: "images/HP/nymphadora.jpg" }
Repo.insert! %User{ first_name: "Arthur", last_name: "Weasley", email: "aw@hogwarts.wiz", photo_url: "images/HP/arthurweasley.jpg" }
Repo.insert! %User{ first_name: "Molly", last_name: "Weasley", email: "mw@hogwarts.wiz", photo_url: "images/HP/mollyweasley.jpg" }
Repo.insert! %User{ first_name: "Cho", last_name: "Chan", email: "cc@hogwarts.wiz", photo_url: "images/HP/cho.jpg" }
Repo.insert! %User{ first_name: "Ginny", last_name: "Weasley", email: "gw@hogwarts.wiz", photo_url: "images/HP/ginny.jpg" }
Repo.insert! %User{ first_name: "Fred", last_name: "Weasley", email: "fw@hogwarts.wiz", photo_url: "images/HP/fredweasley.jpg" }
Repo.insert! %User{ first_name: "George", last_name: "Weasley", email: "george@hogwarts.wiz", photo_url: "images/HP/georgeweasley.jpg" }
