defmodule DynamicInputsWeb.WebhookLiveTest do
  use DynamicInputsWeb.ConnCase

  import Phoenix.LiveViewTest
  import DynamicInputs.EngineFixtures

  @create_attrs %{name: "some name", url: "some url", headers: %{}, payload: "some payload", content_type: "some content_type"}
  @update_attrs %{name: "some updated name", url: "some updated url", headers: %{}, payload: "some updated payload", content_type: "some updated content_type"}
  @invalid_attrs %{name: nil, url: nil, headers: nil, payload: nil, content_type: nil}

  defp create_webhook(_) do
    webhook = webhook_fixture()
    %{webhook: webhook}
  end

  describe "Index" do
    setup [:create_webhook]

    test "lists all webhooks", %{conn: conn, webhook: webhook} do
      {:ok, _index_live, html} = live(conn, ~p"/webhooks")

      assert html =~ "Listing Webhooks"
      assert html =~ webhook.name
    end

    test "saves new webhook", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/webhooks")

      assert index_live |> element("a", "New Webhook") |> render_click() =~
               "New Webhook"

      assert_patch(index_live, ~p"/webhooks/new")

      assert index_live
             |> form("#webhook-form", webhook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#webhook-form", webhook: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/webhooks")

      html = render(index_live)
      assert html =~ "Webhook created successfully"
      assert html =~ "some name"
    end

    test "updates webhook in listing", %{conn: conn, webhook: webhook} do
      {:ok, index_live, _html} = live(conn, ~p"/webhooks")

      assert index_live |> element("#webhooks-#{webhook.id} a", "Edit") |> render_click() =~
               "Edit Webhook"

      assert_patch(index_live, ~p"/webhooks/#{webhook}/edit")

      assert index_live
             |> form("#webhook-form", webhook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#webhook-form", webhook: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/webhooks")

      html = render(index_live)
      assert html =~ "Webhook updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes webhook in listing", %{conn: conn, webhook: webhook} do
      {:ok, index_live, _html} = live(conn, ~p"/webhooks")

      assert index_live |> element("#webhooks-#{webhook.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#webhooks-#{webhook.id}")
    end
  end

  describe "Show" do
    setup [:create_webhook]

    test "displays webhook", %{conn: conn, webhook: webhook} do
      {:ok, _show_live, html} = live(conn, ~p"/webhooks/#{webhook}")

      assert html =~ "Show Webhook"
      assert html =~ webhook.name
    end

    test "updates webhook within modal", %{conn: conn, webhook: webhook} do
      {:ok, show_live, _html} = live(conn, ~p"/webhooks/#{webhook}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Webhook"

      assert_patch(show_live, ~p"/webhooks/#{webhook}/show/edit")

      assert show_live
             |> form("#webhook-form", webhook: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#webhook-form", webhook: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/webhooks/#{webhook}")

      html = render(show_live)
      assert html =~ "Webhook updated successfully"
      assert html =~ "some updated name"
    end
  end
end
