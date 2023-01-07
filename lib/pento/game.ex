defmodule Pento.Game do
  alias Pento.Game.{Board, Pentomino}

  @messages %{
    out_of_bounds: "Out of bounds!",
    illegal_drop: "Illegal drop: Cannot be out-of-bounds or overlapping another piece."
  }

  def maybe_move(%{active_pento: nil} = board, _) do
    {:ok, board}
  end

  def maybe_move(board, move) do
    if move not in ~W[up down left right flip rotate]a,
      do: {:error, "Invalid move"}

    new_pento = apply(Pentomino, move, [board])
    new_board = %{board | active_pento: new_pento}

    if Board.legal_move?(new_board),
      do: {:ok, new_board},
      else: {:error, @messages.out_of_bounds}
  end

  def maybe_drop(board) do
    if Board.legal_drop?(board),
      do: {:ok, Board.drop(board)},
      else: {:error, @messages.illegal_drop}
  end
end
