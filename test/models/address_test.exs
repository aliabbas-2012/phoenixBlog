defmodule BlogTest.AddressTest do
  use BlogTest.ModelCase

  alias BlogTest.Address

  @valid_attrs %{address_type: "some content", street: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Address.changeset(%Address{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Address.changeset(%Address{}, @invalid_attrs)
    refute changeset.valid?
  end
end
