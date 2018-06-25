defmodule Loki.StorageTest do
  use Loki.DataCase

  alias Loki.Storage

  describe "items" do
    alias Loki.Storage.Item

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Storage.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Storage.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Storage.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Storage.create_item(@valid_attrs)
      assert item.content == "some content"
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Storage.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.content == "some updated content"
      assert item.title == "some updated title"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Storage.update_item(item, @invalid_attrs)
      assert item == Storage.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Storage.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Storage.change_item(item)
    end
  end
end
