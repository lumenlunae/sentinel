defmodule Sentinel.Guardian.PipelineJson do
  use Guardian.Plug.Pipeline,
    otp_app: :sentinel,
    module: Sentinel.Guardian,
    error_handler: Sentinel.AuthHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.LoadResource)
end
