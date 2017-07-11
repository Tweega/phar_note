mix ecto.drop
mix ecto.create
mix ecto.migrate
mix run priv/repo/role_seeds.exs
mix run priv/repo/user_seeds.exs
mix run priv/repo/user_role_seeds.exs
mix run priv/repo/equipment_classes_seeds.exs
mix run priv/repo/equipment_precision_seeds.exs
mix run priv/repo/equipment_seeds.exs
