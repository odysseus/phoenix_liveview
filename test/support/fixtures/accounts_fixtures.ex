defmodule Pento.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Accounts` context.
  """

  def unique_user_email(id \\ System.unique_integer()), do: "user#{id}@example.com"
  def valid_user_password(), do: "Exampl3P4ssw0rd!"
  def valid_password_reset(), do: "An0th3rV4lidP@ssword"
  def valid_username(id \\ System.unique_integer()), do: "user#{id}"

  def valid_user_attributes(attrs \\ %{}) do
    id = System.unique_integer()

    Enum.into(attrs, %{
      email: unique_user_email(id),
      password: valid_user_password(),
      password_confirmation: valid_user_password(),
      username: valid_username(id)
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Pento.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
