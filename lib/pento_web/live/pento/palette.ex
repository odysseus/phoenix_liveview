defmodule PentoWeb.Pento.Palette do
  use Phoenix.Component
  alias PentoWeb.Pento.{Shape, Canvas}
  alias Pento.Game.Pentomino
  import PentoWeb.Pento.Colors

  defstruct palette: nil,
            points: nil

  def new(palette, points) do
    %__MODULE__{palette: palette(palette), points: points}
  end

  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))

  defp rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp palette(:all), do: ~W[i l y n p w u v s f x t]a
  defp palette(:small), do: ~W[u v p]a

  def draw(%{shape_names: shape_names} = assigns) do
    shapes =
      shape_names
      |> Enum.with_index()
      |> Enum.map(&pentomino/1)

    assigns = assign(assigns, shapes: shapes)

    ~H"""
    <div id="palette">
      <Canvas.draw viewBox="0 0 500 125">
        <%= for shape <- @shapes do %>
          <Shape.draw
            points={ shape.points }
            fill={ color(shape.color) }
            name={ shape.name } />
        <% end %>
      </Canvas.draw>
    </div>
    """
  end

  defp pentomino({name, i}) do
    {x, y} = {rem(i, 6) * 4 + 3, div(i, 6) * 5 + 3}

    Pentomino.new(name: name, location: {x, y})
    |> Pentomino.to_shape()
  end
end
