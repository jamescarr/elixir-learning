defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education, Ecto.Enum, values: [
      highschool: "high school",
      bachelor: "bachelor's degree",
      graduate: "graduate degree",
      other: "other",
      pnts: "prefer not to say"]

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :user_id, :education])
    |> validate_required([:gender, :year_of_birth, :user_id, :education])
    |> validate_inclusion(
      :gender,
      ["male", "female", "other", "prefer not to say"]
    )
    |> validate_inclusion(:year_of_birth, 1920..2023)

    |> unique_constraint(:user_id)
  end

  def education_options do
    Ecto.Enum.mappings(__MODULE__, :education)
    |> Enum.map(fn {key, value} -> {value, key} end)
  end
end
