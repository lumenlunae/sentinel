# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
config :logger, :console, level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :comeonin, :bcrypt_log_rounds, 4

config :sentinel,
  crypto_provider: Comeonin.Bcrypt,
  auth_handler: Sentinel.AuthHandler

config :sentinel, Sentinel.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  ttl: {30, :days},
  # optional
  verify_issuer: true,
  serializer: Sentinel.GuardianSerializer,
  hooks: Guardian.DB,
  permissions: Application.get_env(:sentinel, :permissions)

config :guardian, Guardian.DB, repo: Application.get_env(:sentinel, :repo)

config :sentinel, Sentinel.Mailer, adapter: Bamboo.LocalAdapter

config :bamboo, :refute_timeout, 10

config :ueberauth, Ueberauth,
  providers: [
    identity: {
      Ueberauth.Strategy.Identity,
      [
        param_nesting: "user",
        callback_methods: ["POST"],
        uid_field: :email
      ]
    }
  ]

import_config "#{Mix.env()}.exs"
