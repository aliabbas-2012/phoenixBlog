defmodule BlogTest.ApplicationHelpers do
  @moduledoc """
  Conveniences for translating and building application messages.
  """
  use Timex
  use Phoenix.HTML
  require IEx

  def user_full_name(changeset) do
      if changeset do
        changeset.first_name <> " " <> changeset.last_name
      end
  end

  @doc """
    A md5 change
  """
  def to_md5(str) do
    Base.encode16(:erlang.md5(str), case: :lower)
  end

  def set_local_time_zone_date do
    timezone = Timezone.get("Asia/Karachi", Timex.now)
  end

  def set_date_against_timezone(timezone,datetime) do
    Timezone.convert(datetime, timezone)
  end

  def message_time(datetime) do
    set_local_time_zone_date|>set_date_against_timezone(datetime)|>Timex.format!("%H:%M", :strftime)
  end

  def correct_image_path(path) do
      String.replace path, "/priv/static/", "/"
  end
  # get logo image
  def logo_image(user) do
    cond do
      user.id ==nil ->
          "/images/admin_lte/normal.png"
      Enum.count(user.images)>0 ->
        "/#{BlogTest.Avatar.thumb_url(List.first(user.images))}"
      user.gender == "Male" ->
        "/images/admin_lte/avatar5.png"
      user.gender == "Female" ->
        "/images/admin_lte/avatar3.png"
      true ->
        "/images/admin_lte/normal.png"
    end
  end

  def split_names(auth) do
    IO.puts "----------------"
    IO.inspect auth
    IEx.pry
    map = %{}
    if Map.get(auth,:name)!=nil do
      names = String.split(auth.name)
      map = Map.put(map,:first_name,List.first(names))
      if Enum.count(names)>1 do
        map = Map.put(map,:last_name,List.first(names))
      end
    end

    if Map.get(auth,:first_name) !=nil do
      map = Map.put(map,:first_name,auth.first_name)
    end
    if Map.get(auth,:last_name) !=nil do
      map = Map.put(map,:last_name,auth.last_name)
    end
    map
  end

  def change_private_room_name(room,current_user_id) do
    if room.room_type=="private" do
      requested_user_id = current_user_id ==  room.user_id && room.user_id_2 || room.user_id
      requested_user =  BlogTest.Repo.get(BlogTest.User,requested_user_id)
      #change the room name
      room = Map.put(room, :name, user_full_name(requested_user))
    end
    room
  end
end
