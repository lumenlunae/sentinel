defmodule Sentinel.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :hashed_confirmation_token, :text
      add :confirmed_at, :naive_datetime
      add :unconfirmed_email, :string

      timestamps()
    end

  end
end
