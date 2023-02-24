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
create_user = fn ->
  timestamp =
    DateTime.utc_now()
    |> DateTime.to_naive()
    |> NaiveDateTime.truncate(:second)
  
  %{points: 0, inserted_at: timestamp, updated_at: timestamp}
end

1..1_000_000
|> Enum.map(fn _ -> create_user.() end)
|> Enum.chunk_every(20_000)
|> Enum.each(&Moonlapse.Repo.insert_all(Moonlapse.Accounts.User, &1))
