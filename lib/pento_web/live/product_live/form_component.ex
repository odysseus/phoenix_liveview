defmodule PentoWeb.ProductLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 9_000_000,
       auto_upload: true,
       progress: &handle_progress/3
     )}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, params) do
    result =
      Catalog.update_product(
        socket.assigns.product,
        product_params(socket, params)
      )

    case result do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, params) do
    case Catalog.create_product(product_params(socket, params)) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp product_params(socket, params) do
    Map.put(params, "image_upload", socket.assigns.image_upload)
  end

  defp handle_progress(:image, entry, socket) do
    :timer.sleep(500)

    if entry.done? do
      {:ok, path} =
        consume_uploaded_entry(
          socket,
          entry,
          &upload_static_file(&1, socket)
          # &upload_image_file(Map.put(&1, :type, entry.client_type), socket)
        )

      {:noreply,
       socket
       |> put_flash(:info, "file #{entry.client_name} uploaded")
       |> assign(:image_upload, path)}
    else
      {:noreply, socket}
    end
  end

  defp upload_static_file(%{path: path}, socket) do
    dest = Path.join("priv/static/uploads", Path.basename(path))
    File.cp!(path, dest)
    {:ok, {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}}
  end

  defp upload_image_file(%{path: path, type: ctype}, socket) do
    ext =
      case ctype do
        "image/jpeg" -> ".jpg"
        "image/png" -> ".png"
      end

    dest = Path.join("priv/static/uploads", Path.basename(path) <> ext)
    File.cp!(path, dest)
    route = Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
    dbg()

    {:ok, {:ok, route}}
  end

  def upload_image_error(%{image: %{errors: errors}}, entry)
      when length(errors) > 0 do
    {_, msg} =
      Enum.find(errors, fn {ref, _} ->
        ref == entry.ref || ref == entry.upload_ref
      end)

    upload_error_msg(msg)
  end

  def upload_image_error(_, _), do: ""

  def upload_error_msg(msg) do
    case msg do
      :not_accepted -> "Invalid file type"
      :too_many_files -> "Too many files"
      :too_large -> "File is too large"
    end
  end
end
