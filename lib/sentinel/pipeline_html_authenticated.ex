defmodule Sentinel.Guardian.PipelineHtmlAuthenticated do
  use Guardian.Plug.Pipeline,
    otp_app: :sentinel,
    module: Sentinel.Guardian,
    error_handler: Sentinel.AuthHandler

  plug(Guardian.Plug.VerifySession)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
