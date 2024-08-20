defmodule DynamicInputs.Marketing.MailingList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mailing_lists" do
    field :title, :string

    embeds_many :emails, EmailNotification, on_replace: :delete do
      field :email, :string
      field :name, :string
    end


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mailing_list, attrs) do
    mailing_list
    |> cast(attrs, [:title])
    |> cast_embed(:emails,
      with: &email_changeset/2,
      sort_param: :emails_sort,
      drop_param: :emails_drop)
    |> validate_required([:title])
  end

  defp email_changeset(email, attrs) do
    email
    |> cast(attrs, [:email, :name])
    # Possibly some validations here
  end
end
