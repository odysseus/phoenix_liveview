defmodule Pento.Game.Board do
  alias Pento.Game.{Pentomino, Shape}

  defstruct active_pento: nil,
            completed_pentos: [],
            palette: [],
            points: []

  def puzzles(), do: ~w[default wide widest medium tiny]a

  def new(palette, points) do
    %__MODULE__{palette: palette(palette), points: points}
  end

  def new(size) do
    case size do
      :tiny -> new(:small, rect(5, 3))
      :widest -> new(:all, rect(20, 3))
      :wide -> new(:all, rect(15, 4))
      :medium -> new(:all, rect(12, 5))
      _ -> new(:all, rect(10, 6))
    end
  end

  defp rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp palette(:all), do: ~w[i l y n p w u v s f x t]a
  defp palette(:small), do: ~w[u v p]a

  def to_shape(board) do
    Shape.__struct__(color: :purple, name: :board, points: board.points)
  end

  def to_shapes(board) do
    board_shape = to_shape(board)

    pento_shapes =
      [board.active_pento | board.completed_pentos]
      |> Enum.reverse()
      |> Enum.filter(& &1)
      |> Enum.map(&Pentomino.to_shape/1)

    [board_shape | pento_shapes]
  end

  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end
  def active?(%{active_pento: %{name: shape_name}}, shape_name), do: true
  def active?(_board, _shape_name), do: false
end
