defmodule PentoWeb.Pento.GameLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket}
  def render(assigns) do
    ~H"""
    <section class="container">
    <h1>Welcome to Pento!</h1>
    </section>
    """
  end
end
