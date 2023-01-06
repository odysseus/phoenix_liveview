defmodule PentoWeb.Pento.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.Pento.Palette

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok,
     socket
     |> assign(puzzle: puzzle)}
  end

  def render(assigns) do
    ~H"""
    <section class="container">
    <h1>Welcome to Pento!</h1>
    <%!-- <Palette.draw shape_names={ ~W[i l y n p w u v s f x t]a } /> --%>
    <Palette.draw shape_names={ ~W[s t y l]a } />
    </section>
    """
  end
end
