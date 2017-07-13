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
alias PharNote.Product


Repo.delete_all(Product)



Repo.insert! %Product{ product_name: "Polyjuice", product_desc: "Changes consumer into likeness of another", active_ingredient: true }
Repo.insert! %Product{ product_name: "LoveAnother", product_desc: "Induces feelings of warmth and tenderness.", active_ingredient: true }
Repo.insert! %Product{ product_name: "Far Sight", product_desc: "User can see the moon clearly", active_ingredient: true }
Repo.insert! %Product{ product_name: "Vampire inhibitor", product_desc: "Suppresses vampire instincts", active_ingredient: true }
Repo.insert! %Product{ product_name: "Chocolate medecine bar", product_desc: "Mrs Pomfrett's Healing chocolate", active_ingredient: false }
Repo.insert! %Product{ product_name: "WhichFlavourChews", product_desc: "Sweets that taste of unexpected essences.  Sometimes unpleasant.", active_ingredient: false }
