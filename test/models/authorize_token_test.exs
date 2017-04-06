defmodule BlogTest.AuthorizeTokenTest do
  use BlogTest.ModelCase

  alias BlogTest.AuthorizeToken

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AuthorizeToken.changeset(%AuthorizeToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AuthorizeToken.changeset(%AuthorizeToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
