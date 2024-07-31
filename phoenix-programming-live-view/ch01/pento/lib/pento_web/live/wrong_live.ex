defmodule PentoWeb.WrongLive do
  alias Pento.Accounts
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign(
      socket,
      Map.merge(
        fresh_game_attributes(),
          %{
            session_id: session["live_socket_id"],
          }
        )
      )
    }
  end

  defp score_guess(guess, correct_number, score) do
    if guess == correct_number do
      {true, "Your decision: #{guess}. YOU ARE CORRECT!", score + 1}
    else
      {false, "Your decision: #{guess}. WRONG! Guess again!", score - 1}
    end
  end

  defp fresh_game_attributes() do
    %{
      score: 0,
      correct_number: :rand.uniform(10),
      message: "Make a guess:",
      game_won: false
    }
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket,
      fresh_game_attributes()
    )}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess = String.to_integer(guess)
    correct_number = socket.assigns.correct_number
    {game_won,  message, score} = score_guess(guess, correct_number, socket.assigns.score)
    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        game_won: game_won
      )
    }
  end

  def time() do
    DateTime.utc_now |> to_string()
  end

  def render(assigns) do
    ~H"""
      <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
      </h2>
      <br/>
      <h2>
        <%= if @game_won do %>
          <.link
            patch={~p"/guess"}
            class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
          >
              Restart Game
          </.link>
        <% else %>
          <%= for n <- 1..10 do %>
            <.link class="bg-blue-500 hover:bg-blue-700
                        text-white font-bold py-2 px-4 border border-blue-700
                        rounded m-1"
                   phx-click="guess" phx-value-number={n} >
              <%= n %>
            </.link>
          <% end %>
        <% end %>
      </h2>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    """
  end
end
