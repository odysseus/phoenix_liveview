defmodule Pento.Game.Shape do
  alias Pento.Game.Point

  defstruct color: :red, name: :z, points: []

  @colors %{
    i: :dark_green,
    l: :green,
    y: :light_green,
    n: :dark_orange,
    p: :orange,
    w: :light_orange,
    u: :dark_gray,
    v: :gray,
    s: :light_gray,
    f: :dark_blue,
    x: :blue,
    t: :light_blue
  }

  @points %{
    i: [{4, 1}, {3, 2}, {3, 3}, {3, 4}, {3, 5}],
    l: [{3, 1}, {3, 2}, {3, 3}, {3, 4}, {4, 4}],
    y: [{3, 1}, {2, 2}, {3, 2}, {3, 3}, {3, 4}],
    n: [{3, 1}, {3, 2}, {3, 3}, {4, 3}, {4, 4}],
    p: [{3, 2}, {4, 3}, {3, 3}, {4, 2}, {3, 4}],
    w: [{2, 2}, {2, 3}, {3, 3}, {3, 4}, {4, 4}],
    u: [{2, 2}, {4, 2}, {2, 3}, {3, 3}, {4, 3}],
    v: [{2, 2}, {2, 3}, {2, 4}, {3, 4}, {4, 4}],
    s: [{3, 2}, {4, 2}, {3, 3}, {2, 4}, {3, 4}],
    f: [{3, 2}, {4, 2}, {2, 3}, {3, 3}, {3, 4}],
    x: [{3, 2}, {2, 3}, {3, 3}, {4, 3}, {3, 4}],
    t: [{2, 2}, {3, 2}, {4, 2}, {3, 3}, {3, 4}]
  }

  def color(key), do: @colors[key]
  def points(key), do: @points[key]

  def new(key, rotation, reflected, location) do
    points =
      key
      |> points
      |> Enum.map(&Point.prepare(&1, rotation, reflected, location))

    %__MODULE__{points: points, color: color(key), name: key}
  end
end
