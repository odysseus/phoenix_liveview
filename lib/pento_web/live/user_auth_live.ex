defmodule PentoWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Pento.Accounts

  def on_mount(_, _params, session, socket) do
    %{"user_token" => user_token} = session

    socket =
      assign(
        socket,
        :current_user,
        Accounts.get_user_by_session_token(user_token)
      )

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/users/log_in")}
    end
  end
end
