defmodule Pento.Game.Pentomino do
  alias Pento.Game.{Point, Shape}

  @default_location {8, 8}

  defstruct name: :i,
            rotation: 0,
            reflected: false,
            location: @default_location

  def new(fields \\ []), do: __struct__(fields)

  def to_shape(pento) do
    Shape.new(pento.name, pento.rotation, pento.reflected, pento.location)
  end

  def rotate(board, direction \\ :right) do
    rot =
      case direction do
        :right -> 90
        :left -> -90
      end

    board
    |> Map.get(:active_pento)
    |> Map.update!(:rotation, &rem(&1 + rot + 360, 360))
  end

  def flip(board) do
    board
    |> Map.get(:active_pento)
    |> Map.update!(:reflected, &(not &1))
  end

  defp shift(board, move) do
    board
    |> Map.get(:active_pento)
    |> Map.update!(:location, &Point.move(&1, move))
  end

  def up(p), do: shift(p, {0, -1})
  def down(p), do: shift(p, {0, 1})
  def left(p), do: shift(p, {-1, 0})
  def right(p), do: shift(p, {1, 0})

  def overlapping?(pento1, pento2) do
    {p1, p2} = {to_shape(pento1).points, to_shape(pento2).points}
    Enum.count(p1 -- p2) != 5
  end
end
