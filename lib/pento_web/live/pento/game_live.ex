defmodule PentoWeb.Pento.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.Pento.Board

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok,
     socket
     |> assign(puzzle: puzzle)}
  end

  def render(assigns) do
    ~H"""
    <section class="container">
    <h1>Welcome to Pento!</h1>
    <.live_component module={Board} puzzle={ @puzzle } id="game" />
    </section>
    """
  end
end
