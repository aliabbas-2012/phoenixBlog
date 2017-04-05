# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BlogTest.Repo.insert!(%BlogTest.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


case BlogTest.Repo.get_by(BlogTest.Room, name:  "Lobby") do
  nil ->
    changeset = %BlogTest.Room{name: "Lobby.", room_type: "public"}
    BlogTest.Repo.insert(changeset)
  _room ->
    false
end
