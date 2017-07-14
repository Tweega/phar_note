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
alias PharNote.ProductStrength
alias Ecto.Changeset


Repo.delete_all(ProductStrength)

add_strength = fn (prod_name, strength) ->
    product = Repo.get_by!(PharNote.Product, product_name: prod_name)

    ps = Repo.insert! (%ProductStrength{strength: strength} )  |> Repo.preload(:product)
    cs = ps
        |> Changeset.change
        |> Changeset.put_assoc(:product, product)

    Repo.update! cs
end

add_strength.("Polyjuice", "last a day")
add_strength.("Polyjuice", "last a week")
add_strength.("Polyjuice", "Could be permanent")
add_strength.("Polyjuice", "Placebo")

add_strength.("LoveAnother", "24 hour fancy")
add_strength.("LoveAnother", "Summer romance")
add_strength.("LoveAnother", "Could be permanent")
add_strength.("LoveAnother", "Placebo")

add_strength.("Vampire inhibitor", "Only full strength")
add_strength.("Vampire inhibitor", "Placebo")

add_strength.("Chocolate medecine bar", "15% cocoa")
add_strength.("Chocolate medecine bar", "30% cocoa")
add_strength.("Chocolate medecine bar", "65% cocoa")
add_strength.("Chocolate medecine bar", "85% cocoa")
add_strength.("Chocolate medecine bar", "Placebo")

add_strength.("WhichFlavourChews", "Mild")
add_strength.("WhichFlavourChews", "Tangy")
add_strength.("WhichFlavourChews", "Overpowering")
add_strength.("WhichFlavourChews", "Placebo")


# Repo.insert! %Product{ product_name: "Polyjuice", product_desc: "Changes consumer into likeness of another", active_ingredient: true }
# Repo.insert! %Product{ product_name: "LoveAnother", product_desc: "Induces feelings of warmth and tenderness.", active_ingredient: true }
# Repo.insert! %Product{ product_name: "Far Sight", product_desc: "User can see the moon clearly", active_ingredient: true }
# Repo.insert! %Product{ product_name: "Vampire inhibitor", product_desc: "Suppresses vampire instincts", active_ingredient: true }
# Repo.insert! %Product{ product_name: "Chocolate medecine bar", product_desc: "Mrs Pomfrett's Healing chocolate", active_ingredient: false }
# Repo.insert! %Product{ product_name: "WhichFlavourChews", product_desc: "Sweets that taste of unexpected essences.  Sometimes unpleasant.", active_ingredient: false }
