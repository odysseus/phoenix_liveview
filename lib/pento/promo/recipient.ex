defmodule Pento.Promo.Recipient do
  defstruct [:name, :email, :message]
  @types %{name: :string, email: :string, message: :string}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required(Map.keys(@types))
    |> validate_format(:email, ~r/^.+@.+\..+/)
    |> validate_length(:message, max: 255)
  end
end
