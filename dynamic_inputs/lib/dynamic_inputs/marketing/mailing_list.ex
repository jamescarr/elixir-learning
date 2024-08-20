defmodule DynamicInputs.Marketing.MailingList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mailing_lists" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mailing_list, attrs) do
    mailing_list
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
