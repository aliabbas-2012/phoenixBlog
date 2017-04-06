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

changeset = BlogTest.Room.changeset(%BlogTest.Room{},%{name: "Lobby.", room_type: "public"})
case BlogTest.Repo.insert(changeset) do
  {:ok, _person} ->
       IO.puts "success"
  {:error, _changeset} ->
       IO.puts "Already have.."
end
