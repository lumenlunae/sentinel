defmodule Sentinel.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :confirmed_at, :naive_datetime
    field :email, :string
    field :hashed_confirmation_token, :string
    field :unconfirmed_email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :hashed_confirmation_token, :confirmed_at, :unconfirmed_email])
    |> validate_required([:email, :hashed_confirmation_token, :confirmed_at, :unconfirmed_email])
  end
end
