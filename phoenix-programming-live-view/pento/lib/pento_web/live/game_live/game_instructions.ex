defmodule PentoWeb.GameLive.GameInstructions do
  use PentoWeb, :live_component

  def show(assigns) do
    ~H"""
    <p>Instructions go here.</p>
    """
  end

end
