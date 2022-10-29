defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       correct: 0,
       attempts: 0,
       message: "Make a guess:"
     )}
  end

  def handle_event("guess", %{"number" => n}, socket) do
    attempts = socket.assigns[:attempts]
    correct = socket.assigns[:correct]

    if String.to_integer(n) == floor(:rand.uniform() * 10 + 1) do
      correct = correct + 1
      attempts = attempts + 1
      accuracy = Float.round(correct / attempts, 2)

      {:noreply,
       assign(socket,
         correct: correct,
         attempts: attempts,
         message: "Correct! Accuracy: #{accuracy}. Make another guess:"
       )}
    else
      attempts = attempts + 1
      accuracy = Float.round(correct / attempts, 2)

      {:noreply,
       assign(socket,
         attempts: attempts,
         message: "Wrong! Accuracy: #{accuracy}. Make another guess:"
       )}
    end
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @correct %> | Attempts: <%= @attempts %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
    </h2>
    """
  end
end
