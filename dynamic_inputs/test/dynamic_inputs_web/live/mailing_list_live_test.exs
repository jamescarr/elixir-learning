defmodule DynamicInputsWeb.MailingListLiveTest do
  use DynamicInputsWeb.ConnCase

  import Phoenix.LiveViewTest
  import DynamicInputs.MarketingFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_mailing_list(_) do
    mailing_list = mailing_list_fixture()
    %{mailing_list: mailing_list}
  end

  describe "Index" do
    setup [:create_mailing_list]

    test "lists all mailing_lists", %{conn: conn, mailing_list: mailing_list} do
      {:ok, _index_live, html} = live(conn, ~p"/mailing_lists")

      assert html =~ "Listing Mailing lists"
      assert html =~ mailing_list.title
    end

    test "saves new mailing_list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/mailing_lists")

      assert index_live |> element("a", "New Mailing list") |> render_click() =~
               "New Mailing list"

      assert_patch(index_live, ~p"/mailing_lists/new")

      assert index_live
             |> form("#mailing_list-form", mailing_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#mailing_list-form", mailing_list: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/mailing_lists")

      html = render(index_live)
      assert html =~ "Mailing list created successfully"
      assert html =~ "some title"
    end

    test "updates mailing_list in listing", %{conn: conn, mailing_list: mailing_list} do
      {:ok, index_live, _html} = live(conn, ~p"/mailing_lists")

      assert index_live |> element("#mailing_lists-#{mailing_list.id} a", "Edit") |> render_click() =~
               "Edit Mailing list"

      assert_patch(index_live, ~p"/mailing_lists/#{mailing_list}/edit")

      assert index_live
             |> form("#mailing_list-form", mailing_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#mailing_list-form", mailing_list: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/mailing_lists")

      html = render(index_live)
      assert html =~ "Mailing list updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes mailing_list in listing", %{conn: conn, mailing_list: mailing_list} do
      {:ok, index_live, _html} = live(conn, ~p"/mailing_lists")

      assert index_live |> element("#mailing_lists-#{mailing_list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#mailing_lists-#{mailing_list.id}")
    end
  end

  describe "Show" do
    setup [:create_mailing_list]

    test "displays mailing_list", %{conn: conn, mailing_list: mailing_list} do
      {:ok, _show_live, html} = live(conn, ~p"/mailing_lists/#{mailing_list}")

      assert html =~ "Show Mailing list"
      assert html =~ mailing_list.title
    end

    test "updates mailing_list within modal", %{conn: conn, mailing_list: mailing_list} do
      {:ok, show_live, _html} = live(conn, ~p"/mailing_lists/#{mailing_list}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Mailing list"

      assert_patch(show_live, ~p"/mailing_lists/#{mailing_list}/show/edit")

      assert show_live
             |> form("#mailing_list-form", mailing_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#mailing_list-form", mailing_list: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/mailing_lists/#{mailing_list}")

      html = render(show_live)
      assert html =~ "Mailing list updated successfully"
      assert html =~ "some updated title"
    end
  end
end
