defmodule Pento.Game.Pentomino do
  alias Pento.Game.{Point, Shape}

  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location {8, 8}

  defstruct name: :i,
            rotation: 0,
            reflected: false,
            location: @default_location

  def new(fields \\ []), do: __struct__(fields)

  def to_shape(pento) do
    Shape.new(pento.name, pento.rotation, pento.reflected, pento.location)
  end

  def rotate(%{rotation: degrees} = p, direction \\ :right) do
    rot = case direction do
      :right -> 90
      :left -> -90
    end

    %{p | rotation: rem(degrees + rot + 360, 360)}
  end

  def rotate_right(%{rotation: degrees} = p) do
    %{p | rotation: rem(degrees + 90, 360)}
  end

  def rotate_left(%{rotation: degrees} = p) do
    %{p | rotation: rem(degrees - 90 + 360, 360)}
  end

  def flip(%{reflected: reflected} = p) do
    %{p | reflected: not reflected}
  end

  defp shift(p, mv) do
    %{p | location: Point.move(p.location, mv)}
  end

  def up(p), do: shift(p, {0, -1})
  def down(p), do: shift(p, {0, 1})
  def left(p), do: shift(p, {-1, 0})
  def right(p), do: shift(p, {1, 0})
end
