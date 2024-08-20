defmodule DynamicInputs.Marketing do
  @moduledoc """
  The Marketing context.
  """

  import Ecto.Query, warn: false
  alias DynamicInputs.Repo

  alias DynamicInputs.Marketing.MailingList

  @doc """
  Returns the list of mailing_lists.

  ## Examples

      iex> list_mailing_lists()
      [%MailingList{}, ...]

  """
  def list_mailing_lists do
    Repo.all(MailingList)
  end

  @doc """
  Gets a single mailing_list.

  Raises `Ecto.NoResultsError` if the Mailing list does not exist.

  ## Examples

      iex> get_mailing_list!(123)
      %MailingList{}

      iex> get_mailing_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mailing_list!(id), do: Repo.get!(MailingList, id)

  @doc """
  Creates a mailing_list.

  ## Examples

      iex> create_mailing_list(%{field: value})
      {:ok, %MailingList{}}

      iex> create_mailing_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mailing_list(attrs \\ %{}) do
    %MailingList{}
    |> MailingList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mailing_list.

  ## Examples

      iex> update_mailing_list(mailing_list, %{field: new_value})
      {:ok, %MailingList{}}

      iex> update_mailing_list(mailing_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mailing_list(%MailingList{} = mailing_list, attrs) do
    mailing_list
    |> MailingList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mailing_list.

  ## Examples

      iex> delete_mailing_list(mailing_list)
      {:ok, %MailingList{}}

      iex> delete_mailing_list(mailing_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mailing_list(%MailingList{} = mailing_list) do
    Repo.delete(mailing_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mailing_list changes.

  ## Examples

      iex> change_mailing_list(mailing_list)
      %Ecto.Changeset{data: %MailingList{}}

  """
  def change_mailing_list(%MailingList{} = mailing_list, attrs \\ %{}) do
    MailingList.changeset(mailing_list, attrs)
  end
end
