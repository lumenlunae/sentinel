defmodule Sentinel.Guardian.PipelineJsonAuthenticated do
  use Guardian.Plug.Pipeline,
    otp_app: :sentinel,
    module: Sentinel.Guardian,
    error_handler: Sentinel.AuthHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
