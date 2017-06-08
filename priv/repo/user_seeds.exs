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

Repo.delete_all(User)


Repo.insert! %User{ first_name: "Harry", last_name: "Potter", email: "hp@hogwarts.wiz", photo_url: "images/HP/harrypotter.jpg" }
Repo.insert! %User{ first_name: "Hermione", last_name: "Granger", email: "hg@hogwarts.wiz", photo_url: "images/HP/hermione.jpg" }
Repo.insert! %User{ first_name: "Ron", last_name: "Weasley", email: "rw@hogwarts.wiz", photo_url: "images/HP/ron.jpg" }

Repo.insert! %User{ first_name: "Draco", last_name: "Malfoy", email: "hp@hogwarts.wiz", photo_url: "images/HP/draco.jpg" }
Repo.insert! %User{ first_name: "Cedric", last_name: "diggory", email: "hp@hogwarts.wiz", photo_url: "images/HP/cedricdiggory.jpg" }
Repo.insert! %User{ first_name: "Neville", last_name: "Longbottom", email: "hp@hogwarts.wiz", photo_url: "images/HP/neville.jpg" }
Repo.insert! %User{ first_name: "Rubeus", last_name: "Hagrid", email: "hp@hogwarts.wiz", photo_url: "images/HP/rubeus.jpg" }
