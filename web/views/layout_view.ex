defmodule BlogTest.LayoutView do
  use BlogTest.Web, :view


  def user_full_name(changeset) do
      if changeset do
        changeset.first_name <> " " <> changeset.last_name
      end
  end
end
