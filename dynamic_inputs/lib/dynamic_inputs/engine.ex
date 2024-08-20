defmodule DynamicInputs.Engine do
  @moduledoc """
  The Engine context.
  """

  import Ecto.Query, warn: false
  alias DynamicInputs.Repo

  alias DynamicInputs.Engine.Webhook

  @doc """
  Returns the list of webhooks.

  ## Examples

      iex> list_webhooks()
      [%Webhook{}, ...]

  """
  def list_webhooks do
    Repo.all(Webhook)
  end

  @doc """
  Gets a single webhook.

  Raises `Ecto.NoResultsError` if the Webhook does not exist.

  ## Examples

      iex> get_webhook!(123)
      %Webhook{}

      iex> get_webhook!(456)
      ** (Ecto.NoResultsError)

  """
  def get_webhook!(id), do: Repo.get!(Webhook, id)

  @doc """
  Creates a webhook.

  ## Examples

      iex> create_webhook(%{field: value})
      {:ok, %Webhook{}}

      iex> create_webhook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_webhook(attrs \\ %{}) do
    %Webhook{}
    |> Webhook.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a webhook.

  ## Examples

      iex> update_webhook(webhook, %{field: new_value})
      {:ok, %Webhook{}}

      iex> update_webhook(webhook, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_webhook(%Webhook{} = webhook, attrs) do
    webhook
    |> Webhook.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a webhook.

  ## Examples

      iex> delete_webhook(webhook)
      {:ok, %Webhook{}}

      iex> delete_webhook(webhook)
      {:error, %Ecto.Changeset{}}

  """
  def delete_webhook(%Webhook{} = webhook) do
    Repo.delete(webhook)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking webhook changes.

  ## Examples

      iex> change_webhook(webhook)
      %Ecto.Changeset{data: %Webhook{}}

  """
  def change_webhook(%Webhook{} = webhook, attrs \\ %{}) do
    Webhook.changeset(webhook, attrs)
  end
end
