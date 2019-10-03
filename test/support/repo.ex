defmodule Sentinel.TestRepo do
  use Ecto.Repo, otp_app: :sentinel, adapter: Ecto.Adapters.Postgres

  def log(_cmd), do: nil
end
