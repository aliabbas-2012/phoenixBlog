defmodule BlogTest.CategoryPostTest do
  use BlogTest.ModelCase

  alias BlogTest.CategoryPost

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CategoryPost.changeset(%CategoryPost{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CategoryPost.changeset(%CategoryPost{}, @invalid_attrs)
    refute changeset.valid?
  end
end
