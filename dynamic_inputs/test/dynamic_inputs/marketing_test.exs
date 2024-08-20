defmodule DynamicInputs.MarketingTest do
  use DynamicInputs.DataCase

  alias DynamicInputs.Marketing

  describe "mailing_lists" do
    alias DynamicInputs.Marketing.MailingList

    import DynamicInputs.MarketingFixtures

    @invalid_attrs %{title: nil}

    test "list_mailing_lists/0 returns all mailing_lists" do
      mailing_list = mailing_list_fixture()
      assert Marketing.list_mailing_lists() == [mailing_list]
    end

    test "get_mailing_list!/1 returns the mailing_list with given id" do
      mailing_list = mailing_list_fixture()
      assert Marketing.get_mailing_list!(mailing_list.id) == mailing_list
    end

    test "create_mailing_list/1 with valid data creates a mailing_list" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %MailingList{} = mailing_list} = Marketing.create_mailing_list(valid_attrs)
      assert mailing_list.title == "some title"
    end

    test "create_mailing_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marketing.create_mailing_list(@invalid_attrs)
    end

    test "update_mailing_list/2 with valid data updates the mailing_list" do
      mailing_list = mailing_list_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %MailingList{} = mailing_list} = Marketing.update_mailing_list(mailing_list, update_attrs)
      assert mailing_list.title == "some updated title"
    end

    test "update_mailing_list/2 with invalid data returns error changeset" do
      mailing_list = mailing_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Marketing.update_mailing_list(mailing_list, @invalid_attrs)
      assert mailing_list == Marketing.get_mailing_list!(mailing_list.id)
    end

    test "delete_mailing_list/1 deletes the mailing_list" do
      mailing_list = mailing_list_fixture()
      assert {:ok, %MailingList{}} = Marketing.delete_mailing_list(mailing_list)
      assert_raise Ecto.NoResultsError, fn -> Marketing.get_mailing_list!(mailing_list.id) end
    end

    test "change_mailing_list/1 returns a mailing_list changeset" do
      mailing_list = mailing_list_fixture()
      assert %Ecto.Changeset{} = Marketing.change_mailing_list(mailing_list)
    end
  end
end
