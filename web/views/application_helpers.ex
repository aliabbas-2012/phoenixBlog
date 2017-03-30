defmodule BlogTest.ApplicationHelpers do
  @moduledoc """
  Conveniences for translating and building application messages.
  """

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


end
