# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Moonlapse.Repo.insert!(%Moonlapse.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
for x <- 1..100_000, do: Moonlapse.Repo.insert!(%Moonlapse.Accounts.User{points: 0})
