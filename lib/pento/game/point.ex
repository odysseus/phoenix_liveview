defmodule Pento.Game.Point do
  def new(x, y) when is_integer(x) and is_integer(y), do: {x, y}
  def move({x, y}, {dx, dy}), do: {x + dx, y + dy}
  def transpose({x, y}), do: {y, x}
  def flip({x, y}), do: {x, 6 - y}
  def reflect({x, y}), do: {6 - x, y}
  def center(point), do: move(point, {-3, -3})
  def maybe_reflect(point, true), do: reflect(point)
  def maybe_reflect(point, false), do: point

  def rotate(point, 0), do: point
  def rotate(point, 90), do: point |> reflect |> transpose
  def rotate(point, 180), do: point |> reflect |> flip
  def rotate(point, 270), do: point |> flip |> transpose

  def prepare(point, rotation, reflected, movement) do
    point
    |> rotate(rotation)
    |> maybe_reflect(reflected)
    |> move(movement)
    |> center
  end
end
