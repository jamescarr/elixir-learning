defmodule PentoWeb.SurveyLive.Show do
  use Phoenix.Component
  alias PentoWeb.CoreComponents
  alias Pento.Survey.Demographic
  alias Pento.EnumHelper

  attr :demographic, Demographic, required: true
  def details(assigns) do
    ~H"""
    <div>
      <CoreComponents.table
        rows={[@demographic]}
        id={to_string @demographic.id} >
        <:col :let={demographic} label="Gender">
          <%= demographic.gender %>
        </:col>
        <:col :let={demographic} label="Year of Birth">
          <%= demographic.year_of_birth %>
        </:col>
        <:col :let={demographic} label="Education">
          <%= education(demographic.education) %>
        </:col>
      </CoreComponents.table>
    </div>
    """
  end

  def education(edu) do
    EnumHelper.display_enum(Demographic, :education, edu)
  end
end
