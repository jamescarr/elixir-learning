defmodule DynamicInputs.EngineTest do
  use DynamicInputs.DataCase

  alias DynamicInputs.Engine

  describe "webhooks" do
    alias DynamicInputs.Engine.Webhook

    import DynamicInputs.EngineFixtures

    @invalid_attrs %{name: nil, url: nil, headers: nil, payload: nil, content_type: nil}

    test "list_webhooks/0 returns all webhooks" do
      webhook = webhook_fixture()
      assert Engine.list_webhooks() == [webhook]
    end

    test "get_webhook!/1 returns the webhook with given id" do
      webhook = webhook_fixture()
      assert Engine.get_webhook!(webhook.id) == webhook
    end

    test "create_webhook/1 with valid data creates a webhook" do
      valid_attrs = %{name: "some name", url: "some url", headers: %{}, payload: "some payload", content_type: "some content_type"}

      assert {:ok, %Webhook{} = webhook} = Engine.create_webhook(valid_attrs)
      assert webhook.name == "some name"
      assert webhook.url == "some url"
      assert webhook.headers == %{}
      assert webhook.payload == "some payload"
      assert webhook.content_type == "some content_type"
    end

    test "create_webhook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Engine.create_webhook(@invalid_attrs)
    end

    test "update_webhook/2 with valid data updates the webhook" do
      webhook = webhook_fixture()
      update_attrs = %{name: "some updated name", url: "some updated url", headers: %{}, payload: "some updated payload", content_type: "some updated content_type"}

      assert {:ok, %Webhook{} = webhook} = Engine.update_webhook(webhook, update_attrs)
      assert webhook.name == "some updated name"
      assert webhook.url == "some updated url"
      assert webhook.headers == %{}
      assert webhook.payload == "some updated payload"
      assert webhook.content_type == "some updated content_type"
    end

    test "update_webhook/2 with invalid data returns error changeset" do
      webhook = webhook_fixture()
      assert {:error, %Ecto.Changeset{}} = Engine.update_webhook(webhook, @invalid_attrs)
      assert webhook == Engine.get_webhook!(webhook.id)
    end

    test "delete_webhook/1 deletes the webhook" do
      webhook = webhook_fixture()
      assert {:ok, %Webhook{}} = Engine.delete_webhook(webhook)
      assert_raise Ecto.NoResultsError, fn -> Engine.get_webhook!(webhook.id) end
    end

    test "change_webhook/1 returns a webhook changeset" do
      webhook = webhook_fixture()
      assert %Ecto.Changeset{} = Engine.change_webhook(webhook)
    end
  end
end
