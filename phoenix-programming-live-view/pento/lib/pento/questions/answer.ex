defmodule Pento.Questions.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :body, :string
    field :votes, :integer
    field :question_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:body, :votes])
    |> validate_required([:body, :votes])
  end
end
