defmodule BlogTest.ApplicationHelpers do
  @moduledoc """
  Conveniences for translating and building application messages.
  """
  use Timex
  use Phoenix.HTML

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


end
