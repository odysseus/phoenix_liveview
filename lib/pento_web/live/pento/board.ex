defmodule PentoWeb.Pento.Board do
  use PentoWeb, :live_component
  alias PentoWeb.Pento.{Canvas, Palette, Shape}
  alias Pento.Game.Board
  alias Pento.Game
  import PentoWeb.Pento.Colors

  def render(assigns) do
    ~H"""
    <div id={ @id } phx-window-keydown="key" phx-target={ @myself }>
      <p class="alert alert-info" role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="info"><%= live_flash(@flash, :info) %></p>
      <Canvas.draw viewBox="0 0 200 70">
        <%= for shape <- @shapes do %>
          <Shape.draw
            points={ shape.points }
            fill={ color(shape.color, Board.active?(@board, shape.name)) }
            name={ shape.name } />
        <% end %>
      </Canvas.draw>
      <hr/>
      <Palette.draw
        shape_names={ @palette }
        id="palette" />
      </div>
    """
  end

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_default_flash()
     |> assign_params(id, puzzle)
     |> assign_board()
     |> assign_palette()
     |> assign_shapes()}
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    board =
      puzzle
      |> parse_size
      |> Board.new()
      |> Map.put(:completed_pentos, [])
      |> Map.put(:active_pento, nil)

    assign(socket, board: board)
  end

  defp parse_size(str) do
    if str in ~W|tiny widest wide medium default| do
      String.to_atom(str)
    end
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = Board.to_shapes(board)
    assign(socket, shapes: shapes)
  end

  def assign_palette(%{assigns: %{board: board}} = socket) do
    socket
    |> assign(:palette, Board.palette_remaining(board))
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {:noreply,
     socket
     |> assign_default_flash
     |> pick(name)
     |> assign_palette
     |> assign_shapes}
  end

  def handle_event("key", %{"key" => key}, socket) do
    {:noreply,
     socket
     |> assign_default_flash
     |> handle_key(key)
     |> assign_palette
     |> assign_shapes}
  end

  def assign_default_flash(socket) do
    socket
    |> put_flash(
      :info,
      "Click to select | Arrows to move | Shift to rotate | Z to flip | SPACE to drop | ESC to deselect"
    )
  end

  defp pick(socket, "board"), do: socket

  defp pick(%{assigns: %{board: board}} = socket, name) do
    shape_name = atomize_shape_name(name)

    socket
    |> assign(board: Board.pick(board, shape_name))
  end

  defp atomize_shape_name(name) do
    if name in ~W[i l y n p w u v s f x t],
      do: String.to_atom(name),
      else: nil
  end

  defp handle_key(socket, key) do
    case key do
      " " -> drop(socket)
      "ArrowLeft" -> move(socket, :left)
      "ArrowRight" -> move(socket, :right)
      "ArrowUp" -> move(socket, :up)
      "ArrowDown" -> move(socket, :down)
      "Shift" -> move(socket, :rotate)
      "z" -> move(socket, :flip)
      "Space" -> drop(socket)
      "Escape" -> deselect(socket)
      _ -> socket
    end
  end

  defp move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:error, message} ->
        put_flash(socket, :info, message)

      {:ok, board} ->
        socket
        |> assign(board: board)
        |> assign_shapes
    end
  end

  defp drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:error, message} ->
        put_flash(socket, :info, message)

      {:ok, board} ->
        socket
        |> assign(board: board)
        |> assign_shapes
    end
  end

  defp deselect(%{assigns: %{board: board}} = socket) do
    socket
    |> assign(:board, %{board | active_pento: nil})
  end
end
