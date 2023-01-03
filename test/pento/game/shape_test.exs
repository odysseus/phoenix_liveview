defmodule Pento.Game.ShapeTest do
  use ExUnit.Case
  alias Pento.Game.Shape

  describe "shape creation" do
    test "gives the correct color" do
      assert Shape.color(:l) == :green
      assert Shape.color(:x) == :blue
      assert Shape.color(:w) == :light_orange
    end

    test "gives the correct points" do
      assert Shape.points(:x) == [{3, 2}, {2, 3}, {3, 3}, {4, 3}, {3, 4}]
    end

    test "new with no transformations" do
      assert %Shape{
               points: [{3, 2}, {4, 2}, {3, 3}, {2, 4}, {3, 4}],
               name: :s,
               color: :light_gray
             } = Shape.new(:s, 0, false, {3, 3})
    end
  end
end
