defmodule PentoWeb.SurveyLive.ListComponent do
  use Phoenix.Component

  attr :questions, :list

  slot :inner_block


  def item(assigns) do
    ~H"""
      <li><%= @inner_block %></li>
    """
  end

  def survey(assigns) do
    ~H"""
    <ul>
      <%= for question <- @questions do %>
      <.item><%= question %></.item>
      <% end %>
    </ul>
    """
  end
end
